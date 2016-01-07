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

%������Ի����ȡ����������

InputdlgOptions.Resize = 'on';
InputdlgOptions.WindowStyle = 'normal';

if exist('LastSubjectName.mat','file')
    load LastSubjectName.mat;
    SubjectName = inputdlg('Subject Name:','����������������',[1,42],{LastSubjectName},InputdlgOptions);
else
    SubjectName = inputdlg('Subject Name:','����������������',[1,42],{'ABC'},InputdlgOptions);
end

if isempty(SubjectName)
    return;
end

%�洢���������������Ϊ����ʵ���������Ƶ�Ĭ��ֵ
LastSubjectName = SubjectName{1};

save LastSubjectName.mat LastSubjectName;


DateString = datestr(now,'yyyymmdd_HH-MM-SS');



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
    LevelTopPriority = MaxPriority(PointerWindow,'KbCheck','KbWait','GetSecs');
    %��ȡ��Ļ�ֱ��� SizeScreenX,SizeScreenY�ֱ�ָ���������ķֱ���
    [SizeScreenX, SizeScreenY] = Screen('WindowSize', PointerWindow);
    
    %����Exp_ParameterSetting.m������Ӧ����
    Exp_ParameterSetting;
    
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
    
    DataWhiteNoise = wgn(2,round(TimeWhiteNoise*AudioSampleRate),PowerWhiteNoise);
    
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
    
    
    HandleWhiteNoiseBuffer = PsychPortAudio('CreateBuffer',HandlePortAudio,...
        [zeros(2,round(TimeGapSilence*AudioSampleRate)),DataWhiteNoise,zeros(2,round(TimeGapSilence*AudioSampleRate))]);
    
    
    
    %���е�һ��Flip�Ի�ȡ��ǰʱ��
    vbl = Screen('Flip', PointerWindow);
    
    PatternRangeMin = min(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    PatternRangeMax = max(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    
    iPattern = randi([PatternRangeMin,PatternRangeMax],1,NumTrial);
    
    t = linspace(0,TimeHintSound/6,round(TimeHintSound/6*AudioSampleRate));
    
    
    DataHintSound =  0.5*sin(2*pi*FreqHintSound*t);
    
    %���뵭��
    NumPointFadeIn = 8000;
    
    NumPointFadeOut = 8000;
    
    t = (-1*round(NumPointFadeIn):-1)/AudioSampleRate;
    
    FreqFadeIn = AudioSampleRate/(2*NumPointFadeIn);
    
    AmpFadeIn = (cos(2*pi*FreqFadeIn*t)+1)/2;
    
    t = (1:round(NumPointFadeOut))/AudioSampleRate;
    
    FreqFadeOut = AudioSampleRate/(2*NumPointFadeOut);
    
    AmpFadeOut = (cos(2*pi*FreqFadeOut*t)+1)/2;
    
    
    DataHintSound(:,1:NumPointFadeIn)=DataHintSound(:,1:NumPointFadeIn).*AmpFadeIn;
    
    
    DataHintSound(:,end-NumPointFadeIn+1:end)=DataHintSound(:,end-NumPointFadeIn+1:end).*AmpFadeOut;
    
    
    DataHintSound = repmat([DataHintSound,zeros(1,TimeHintSound/6*AudioSampleRate)],1,3);
    
    PsychPortAudio('Stop', HandlePortAudio);
    
    %����ʾ����䵽PortAudio�����Buffer��
    PsychPortAudio('FillBuffer', HandlePortAudio,repmat(DataHintSound,2,1));
    %������ʾ��
    PsychPortAudio('Start', HandlePortAudio, 1, AudioStartTime, WaitUntilDeviceStart);
    

    [~, KeyCode,~] = KbWait([],0,GetSecs+TimeHintSound);
    if KeyCode(KbName('ESCAPE'))
        %         %���ڱ��253��ʾʵ����Esc�������¶���ǰ����
        %         lptwrite(LptAddress,253);
        %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
        %         WaitSecs(0.1);
        %         %��������0
        %         lptwrite(LptAddress,0);
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
    end
    
    
    PsychPortAudio('Stop', HandlePortAudio);
    
    %         %���ڱ��251��ʾʵ�鿪ʼ
    %         lptwrite(LptAddress,251);
    %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
    %         WaitSecs(0.1);
    %         %��������0
    %         lptwrite(LptAddress,0);
    
    iPattern = randi([PatternRangeMin,PatternRangeMax],1,NumTrial);
    
    iTrial = 0;
    
    while  iTrial < NumTrial
        iTrial = iTrial + 1;
        if iTrial == 1 ||(iTrial >1 && iPattern(iTrial-1) ~= iPattern(iTrial))
            eval(['Pattern',num2str(iPattern(iTrial))]);
            eval(['load Sound',num2str(iPattern(iTrial)),'.mat']);
        end
        
        %��䵽PortAudio�����Buffer��
        PsychPortAudio('FillBuffer', HandlePortAudio,HandleWhiteNoiseBuffer);
        %��������
        PsychPortAudio('Start', HandlePortAudio, 1, AudioStartTime, WaitUntilDeviceStart);
        
        %         %���ڱ��250��ʾ��ʼTrial��ʼ(����->��˹->����->��������->����->��������->����...)
        %         lptwrite(LptAddress,250);
        %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
        %         WaitSecs(0.1);
        %         %��������0
        %         lptwrite(LptAddress,0);
        
        [~, KeyCode,~] = KbWait([],0,GetSecs+TimeWhiteNoise+2*TimeGapSilence-0.1);
        if KeyCode(KbName('ESCAPE'))
            %         %���ڱ��253��ʾʵ����Esc�������¶���ǰ����
            %         lptwrite(LptAddress,253);
            %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
            %         WaitSecs(0.1);
            %         %��������0
            %         lptwrite(LptAddress,0);
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
            %         %���ڱ��252��ʾʵ����ת����һ��ͼ��
            %         lptwrite(LptAddress,252);
            %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
            %         WaitSecs(0.1);
            %         %��������0
            %         lptwrite(LptAddress,0);
            PsychPortAudio('Stop', HandlePortAudio);
            %�ȴ��ո���ɿ�
            KbWait([],1);
            continue;
        end
        
        
        %��䵽PortAudio�����Buffer��
        PsychPortAudio('FillBuffer', HandlePortAudio,...
            [DataAudio,zeros(2,round(TimeGapSilence*AudioSampleRate))]);
        %��������
        PsychPortAudio('Start', HandlePortAudio, 0, AudioStartTime, WaitUntilDeviceStart);
        
        %         %���ڱ�Ǳ�ʾ����������ʼ����
        %         lptwrite(LptAddress,mod(iPattern(iTrial)-1,200)+1);
        %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
        %         WaitSecs(0.1);
        %         %��������0
        %         lptwrite(LptAddress,0);
        
        
        %�ȴ�
        [~, KeyCode,~] = KbWait([],0);
        if KeyCode(KbName('ESCAPE'))
            
            %         %���ڱ��253��ʾʵ����Esc�������¶���ǰ����
            %         lptwrite(LptAddress,253);
            %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
            %         WaitSecs(0.1); 
            %         %��������0
            %         lptwrite(LptAddress,0);
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
            %         %���ڱ��252��ʾʵ����ת����һ��ͼ��
            %         lptwrite(LptAddress,252);
            %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
            %         WaitSecs(0.1);
            %         %��������0
            %         lptwrite(LptAddress,0);
            PsychPortAudio('Stop', HandlePortAudio);
            %�ȴ��ո���ɿ�
            KbWait([],1);
            continue;
        end
        
        
    end
    
    
    %         %���ڱ��254��ʾʵ����������
    %         lptwrite(LptAddress,254);
    %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
    %         WaitSecs(0.1);
    %         %��������0
    %         lptwrite(LptAddress,0);
    
    %%
    %�洢��¼�ļ�
    %��¼�ļ�·��
    RecordPath = ['.',filesep,'RecordFiles',filesep,SubjectName{1}];
    if ~exist(RecordPath,'dir')
        mkdir(RecordPath);
    end
    %��¼�ļ���
    RecordFile = [RecordPath,filesep,DateString,'.mat'];
    
    %�洢�ı�������NumCodeDot,NumTrial,SequenceCodeDot
    save(RecordFile,'iPattern');
    
    
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
