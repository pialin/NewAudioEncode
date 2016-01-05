%此程序为正式实验程序
%软件环境：
%Psychtoolbox:3.0.12
%Matlab:R2015a x64
%Windows 8.1 x64

%%
close all;
clear;
sca;

%修改工作路径至当前M文件所在目录
Path=mfilename('fullpath');
FileSepIndex = strfind(Path,filesep);
cd(Path(1:FileSepIndex(end)));

%获取当前Matlab版本
MatlabRelease = version('-release');


%随机数生成器状态设置
if str2double(MatlabRelease(1:end-1))>=2011%Matla为R2011之后版本
    rng('shuffle');
else
    rand('twister',mod(floor(now*8640000),2^31-1));%Matlab为R2011之前版本
end
%%
%显示部分设置
%执行默认设置2
%相当于执行了以下三条语句：
%“AssertOpenGL;” 确保Screen函数被正确安装
%“KbName('UnifyKeyNames');” 设置一套适用于所有操作系统的统一的KeyCode（按键码）和KeyName（按键名）对(MacOS-X),使用“ KbName('KeyNamesOSX')”查看
%在创建窗口后立刻执行“Screen('ColorRange', PointerWindow, 1, [],1);”将颜色的设定方式由3个8位无符号整数组成的三维向量改成3个0到1的浮点数三维向量，目的是为了同时兼容不同颜色位数的显示器（比如8位和16位显示器）
PsychDefaultSetup(2);

% %键盘响应设置
% %Matlab命令行窗口停止响应键盘字符输入（按Crtl+C可以取消这一状态）
% ListenChar(2);

%限制KbCheck响应的按键范围（只有Esc及space键可以触发KbCheck）
RestrictKeysForKbCheck([KbName('ESCAPE'),KbName('space')]);


%获取所有显示器的序号
AllScreen = Screen('Screens');
%取最大的显示器序号：若有外接显示器，保证呈现范式所用的显示器为外接显示器
ScreenNumber = max(AllScreen);

%获取黑白对应的颜色设定值并据此计算其他一些颜色的设定值
white = WhiteIndex(ScreenNumber);
black = BlackIndex(ScreenNumber);

%运行用到的mex函数以节省后续调用时间
GetSecs;
WaitSecs(0.1);
KbWait([],1);



%%
%try catch语句保证在程序执行过程中出错可以及时关闭创建的window和PortAudio对象，正确退出程序
try
    
    %创建一个窗口对象，返回对象指针PointerWindow,第三个参数设置新建窗口的背景色为黑色
    PointerWindow = PsychImaging('OpenWindow', ScreenNumber, black);
    
    %获取每次帧刷新之间的时间间隔
    TimePerFlip = Screen('GetFlipInterval', PointerWindow);
    
    %计算每秒刷新的帧数
    FramePerSecond =1/TimePerFlip;
    
    %获取可用的屏幕显示优先级？？
    LevelTopPriority = MaxPriority(PointerWindow,'KbCheck','KbWait');
    %获取屏幕分辨率 SizeScreenX,SizeScreenY分别指横向和纵向的分辨率
    [SizeScreenX, SizeScreenY] = Screen('WindowSize', PointerWindow);
    
    %调用ExpTrain_ParameterSetting.m设置相应参数
    ExpTrain_ParameterSetting;
    
    %字体和大小设定
    Screen('TextFont', PointerWindow, FontName);
    Screen('TextSize', PointerWindow ,FontSize);
    %设置Alpha-Blending相应参数
    Screen('BlendFunction', PointerWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    %等待帧数设定，后面用于保证准确的帧刷新时序
    FrameWait = 1;
    
    
    %%
    %音频设置
    
    %开启低延迟模式
    EnableSoundLowLatencyMode = 1;
    InitializePsychSound(EnableSoundLowLatencyMode);
    
    %设置音频声道数为2，即左右双声道立体声
    NumAudioChannel = 2;
    
    %PsyPortAudio('Start',...)语句执行后立刻开始播放声音
    AudioStartTime = 0;
    %等待声音真正播放后退出语句执行下面语句
    WaitUntilDeviceStart = 1;
    
    
    
    % 创建PortAudio对象，对应的参数如下
    % (1) [] ,调用默认的声卡
    % (2) 1 ,仅进行声音播放（不进行声音录制）
    % (3) 1 , 默认延迟模式
    % (4) SampleRateAudio,音频采样率
    % (5) 2 ,输出声道数为2
    HandlePortAudio = PsychPortAudio('Open', [], 1, EnableSoundLowLatencyMode,AudioSampleRate, NumAudioChannel);
    
    %播放音量设置
    PsychPortAudio('Volume', HandlePortAudio, AudioVolume);
    
    DataWhiteNoise = wgn(2,TimeWhiteNoise*AudioSampleRate,PowerWhiteNoise);
    
    DataWhiteNoise = DataWhiteNoise/max(abs(DataWhiteNoise(:)))*0.6;
    
    %淡入淡出
    NumPointFadeIn = 1000;
    
    NumPointFadeOut = 1000;
    
    t = (-1*round(NumPointFadeIn):-1)/AudioSampleRate;
    
    FreqFadeIn = AudioSampleRate/(2*NumPointFadeIn);
    
    AmpFadeIn = (cos(2*pi*FreqFadeIn*t)+1)/2;
    
    t = (1:round(NumPointFadeOut))/AudioSampleRate;
    
    FreqFadeOut = AudioSampleRate/(2*NumPointFadeOut);
    
    AmpFadeOut = (cos(2*pi*FreqFadeOut*t)+1)/2;
    
    
    DataWhiteNoise(:,1:NumPointFadeIn)=DataWhiteNoise(:,1:NumPointFadeIn).*repmat(AmpFadeIn,2,1);
    
    
    DataWhiteNoise(:,end-NumPointFadeIn+1:end)=DataWhiteNoise(:,end-NumPointFadeIn+1:end).*repmat(AmpFadeOut,2,1);
    
    
    %     HandleWhiteNoiseBuffer = PsychPortAudio('CreateBuffer',HandlePortAudio,DataWhiteNoise);
    
    
    
    %进行第一次Flip以获取当前时间
    vbl = Screen('Flip', PointerWindow);
    
    PatternRangeMin = min(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    PatternRangeMax = max(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    
    iPattern = randi([PatternRangeMin,PatternRangeMax],1,NumTrial);
    
    t = linspace(0,TimeHintSound/6,round(TimeHintSound/6*AudioSampleRate));
    

    DataHintSound =  sin(2*pi*FreqHintSound*t);
    
    DataHintSound = repmat([DataHintSound,zeros(1,TimeHintSound/6*AudioSampleRate)],1,3);
    
    PsychPortAudio('Stop', HandlePortAudio);
    
    %将提示音填充到PortAudio对象的Buffer中
    PsychPortAudio('FillBuffer', HandlePortAudio,repmat(DataHintSound,2,1));
    %播放提示音
    PsychPortAudio('Start', HandlePortAudio, 1, AudioStartTime, WaitUntilDeviceStart);
    
    pause(TimeHintSound);
    
    
    
    
    for iTrial =1:NumTrial
        
        eval(['Pattern',num2str(iPattern(iTrial))]);
        eval(['load Sound',num2str(iPattern(iTrial)),'.mat']);
        
        PsychPortAudio('Stop', HandlePortAudio);
        
        %填充到PortAudio对象的Buffer中
        PsychPortAudio('FillBuffer', HandlePortAudio,...
            [DataWhiteNoise,zeros(2,TimeSilence1*AudioSampleRate),DataAudio,zeros(2,TimeSilence2*AudioSampleRate),DataAudio]);
        %播放声音
        PsychPortAudio('Start', HandlePortAudio, 1, AudioStartTime, WaitUntilDeviceStart);
        
        %等待
        % WaitSecs(TimeWhiteNoise+TimeSilence1+2*TimeCodeSound+TimeSilence2);
        pause(TimeWhiteNoise+TimeSilence1+2*TimeCodeSound+TimeSilence2);
        
        vbl = Screen('Flip', PointerWindow);
        
        [~, KeyCode,~] = KbWait([],0,GetSecs+TimeSilence3);
        if KeyCode(KbName('ESCAPE'))
            %关闭PortAudio对象
            PsychPortAudio('Close');
            %恢复显示优先级
            Priority(0);
            %关闭所有窗口对象
            sca;
            %恢复键盘设定
            %恢复Matlab命令行窗口对键盘输入的响应
            ListenChar(0);
            %恢复KbCheck函数对所有键盘输入的响应
            RestrictKeysForKbCheck([]);
            %终止程序
            return;
        elseif KeyCode(KbName('space'))
            
            PsychPortAudio('Stop', HandlePortAudio);
            
        end
        
    end
    
    
    %恢复Matlab命令行窗口对键盘输入的响应
    ListenChar(0);
    %恢复KbCheck函数对所有键盘输入的响应
    RestrictKeysForKbCheck([]);
    PsychPortAudio('Close');
    sca;
    
    
    
    
    %%
    %如果程序执行出错则执行下面程序
catch Error
    
    PsychPortAudio('Close');
    sca;
    %恢复Matlab命令行窗口对键盘输入的响应
    ListenChar(0);
    %恢复KbCheck函数对所有键盘输入的响应
    RestrictKeysForKbCheck([]);
    
    
    rethrow(Error);
    
end
