%�˳���Ϊ��ʽʵ�����
%���������
%Psychtoolbox:3.0.12
%Matlab:R2015a x64
%Windows 8.1 x64

%%
close all;
clear;
sca;

%�޸Ĺ���·������ǰM�ļ�����Ŀ¼
Path=mfilename('fullpath');
FileSepIndex = strfind(Path,filesep);
cd(Path(1:FileSepIndex(end)));

%��ȡ��ǰMatlab�汾
MatlabRelease = version('-release');


%�����������״̬����
if str2double(MatlabRelease(1:end-1))>=2011%MatlaΪR2011֮��汾
    rng('shuffle');
else
    rand('twister',mod(floor(now*8640000),2^31-1));%MatlabΪR2011֮ǰ�汾
end
%%
%��ʾ��������
%ִ��Ĭ������2
%�൱��ִ��������������䣺
%��AssertOpenGL;�� ȷ��Screen��������ȷ��װ
%��KbName('UnifyKeyNames');�� ����һ�����������в���ϵͳ��ͳһ��KeyCode�������룩��KeyName������������(MacOS-X),ʹ�á� KbName('KeyNamesOSX')���鿴
%�ڴ������ں�����ִ�С�Screen('ColorRange', PointerWindow, 1, [],1);������ɫ���趨��ʽ��3��8λ�޷���������ɵ���ά�����ĳ�3��0��1�ĸ�������ά������Ŀ����Ϊ��ͬʱ���ݲ�ͬ��ɫλ������ʾ��������8λ��16λ��ʾ����
PsychDefaultSetup(2);

% %������Ӧ����
% %Matlab�����д���ֹͣ��Ӧ�����ַ����루��Crtl+C����ȡ����һ״̬��
% ListenChar(2);

%����KbCheck��Ӧ�İ�����Χ��ֻ��Esc��space�����Դ���KbCheck��
RestrictKeysForKbCheck([KbName('ESCAPE'),KbName('space')]);


%��ȡ������ʾ�������
AllScreen = Screen('Screens');
%ȡ������ʾ����ţ����������ʾ������֤���ַ�ʽ���õ���ʾ��Ϊ�����ʾ��
ScreenNumber = max(AllScreen);

%��ȡ�ڰ׶�Ӧ����ɫ�趨ֵ���ݴ˼�������һЩ��ɫ���趨ֵ
white = WhiteIndex(ScreenNumber);
black = BlackIndex(ScreenNumber);

%�����õ���mex�����Խ�ʡ��������ʱ��
GetSecs;
WaitSecs(0.1);
KbWait([],1);



%%
%try catch��䱣֤�ڳ���ִ�й����г�����Լ�ʱ�رմ�����window��PortAudio������ȷ�˳�����
try
    
    %����һ�����ڶ��󣬷��ض���ָ��PointerWindow,���������������½����ڵı���ɫΪ��ɫ
    PointerWindow = PsychImaging('OpenWindow', ScreenNumber, black);
    
    %��ȡÿ��֡ˢ��֮���ʱ����
    TimePerFlip = Screen('GetFlipInterval', PointerWindow);
    
    %����ÿ��ˢ�µ�֡��
    FramePerSecond =1/TimePerFlip;
    
    %��ȡ���õ���Ļ��ʾ���ȼ�����
    LevelTopPriority = MaxPriority(PointerWindow,'KbCheck','KbWait');
    %��ȡ��Ļ�ֱ��� SizeScreenX,SizeScreenY�ֱ�ָ���������ķֱ���
    [SizeScreenX, SizeScreenY] = Screen('WindowSize', PointerWindow);
    
    %����ExpTrain_ParameterSetting.m������Ӧ����
    ExpTrain_ParameterSetting;
    
    %����ʹ�С�趨
    Screen('TextFont', PointerWindow, FontName);
    Screen('TextSize', PointerWindow ,FontSize);
    %����Alpha-Blending��Ӧ����
    Screen('BlendFunction', PointerWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    %�ȴ�֡���趨���������ڱ�֤׼ȷ��֡ˢ��ʱ��
    FrameWait = 1;
    
    
    %%
    %��Ƶ����
    
    %�������ӳ�ģʽ
    EnableSoundLowLatencyMode = 1;
    InitializePsychSound(EnableSoundLowLatencyMode);
    
    %������Ƶ������Ϊ2��������˫����������
    NumAudioChannel = 2;
    
    %PsyPortAudio('Start',...)���ִ�к����̿�ʼ��������
    AudioStartTime = 0;
    %�ȴ������������ź��˳����ִ���������
    WaitUntilDeviceStart = 1;
    
    
    
    % ����PortAudio���󣬶�Ӧ�Ĳ�������
    % (1) [] ,����Ĭ�ϵ�����
    % (2) 1 ,�������������ţ�����������¼�ƣ�
    % (3) 1 , Ĭ���ӳ�ģʽ
    % (4) SampleRateAudio,��Ƶ������
    % (5) 2 ,���������Ϊ2
    HandlePortAudio = PsychPortAudio('Open', [], 1, EnableSoundLowLatencyMode,AudioSampleRate, NumAudioChannel);
    
    %������������
    PsychPortAudio('Volume', HandlePortAudio, AudioVolume);
    
    DataWhiteNoise = wgn(2,TimeWhiteNoise*AudioSampleRate,PowerWhiteNoise);
    
    DataWhiteNoise = DataWhiteNoise/max(abs(DataWhiteNoise(:)))*0.6;
    
    %���뵭��
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
    
    
    
    %���е�һ��Flip�Ի�ȡ��ǰʱ��
    vbl = Screen('Flip', PointerWindow);
    
    PatternRangeMin = min(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    PatternRangeMax = max(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    
    iPattern = randi([PatternRangeMin,PatternRangeMax],1,NumTrial);
    
    t = linspace(0,TimeHintSound/6,round(TimeHintSound/6*AudioSampleRate));
    

    DataHintSound =  sin(2*pi*FreqHintSound*t);
    
    DataHintSound = repmat([DataHintSound,zeros(1,TimeHintSound/6*AudioSampleRate)],1,3);
    
    PsychPortAudio('Stop', HandlePortAudio);
    
    %����ʾ����䵽PortAudio�����Buffer��
    PsychPortAudio('FillBuffer', HandlePortAudio,repmat(DataHintSound,2,1));
    %������ʾ��
    PsychPortAudio('Start', HandlePortAudio, 1, AudioStartTime, WaitUntilDeviceStart);
    
    pause(TimeHintSound);
    
    
    
    
    for iTrial =1:NumTrial
        
        eval(['Pattern',num2str(iPattern(iTrial))]);
        eval(['load Sound',num2str(iPattern(iTrial)),'.mat']);
        
        PsychPortAudio('Stop', HandlePortAudio);
        
        %��䵽PortAudio�����Buffer��
        PsychPortAudio('FillBuffer', HandlePortAudio,...
            [DataWhiteNoise,zeros(2,TimeSilence1*AudioSampleRate),DataAudio,zeros(2,TimeSilence2*AudioSampleRate),DataAudio]);
        %��������
        PsychPortAudio('Start', HandlePortAudio, 1, AudioStartTime, WaitUntilDeviceStart);
        
        %�ȴ�
        % WaitSecs(TimeWhiteNoise+TimeSilence1+2*TimeCodeSound+TimeSilence2);
        pause(TimeWhiteNoise+TimeSilence1+2*TimeCodeSound+TimeSilence2);
        
        vbl = Screen('Flip', PointerWindow);
        
        [~, KeyCode,~] = KbWait([],0,GetSecs+TimeSilence3);
        if KeyCode(KbName('ESCAPE'))
            %�ر�PortAudio����
            PsychPortAudio('Close');
            %�ָ���ʾ���ȼ�
            Priority(0);
            %�ر����д��ڶ���
            sca;
            %�ָ������趨
            %�ָ�Matlab�����д��ڶԼ����������Ӧ
            ListenChar(0);
            %�ָ�KbCheck���������м����������Ӧ
            RestrictKeysForKbCheck([]);
            %��ֹ����
            return;
        elseif KeyCode(KbName('space'))
            
            PsychPortAudio('Stop', HandlePortAudio);
            
        end
        
    end
    
    
    %�ָ�Matlab�����д��ڶԼ����������Ӧ
    ListenChar(0);
    %�ָ�KbCheck���������м����������Ӧ
    RestrictKeysForKbCheck([]);
    PsychPortAudio('Close');
    sca;
    
    
    
    
    %%
    %�������ִ�г�����ִ���������
catch Error
    
    PsychPortAudio('Close');
    sca;
    %�ָ�Matlab�����д��ڶԼ����������Ӧ
    ListenChar(0);
    %�ָ�KbCheck���������м����������Ӧ
    RestrictKeysForKbCheck([]);
    
    
    rethrow(Error);
    
end
