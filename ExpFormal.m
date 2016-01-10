%�˳���Ϊ��ʽʵ�����
%���������
%Psychtoolbox:3.0.12
%Matlab:R2015a x64
%Windows 8.1 x64

%%
%�ر����л�ͼ���ڲ�������б���
close all;
clear;
%�ر��Ѿ��򿪵�Psych����
sca;

%�޸Ĺ���·������ǰM�ļ�����Ŀ¼
Path=mfilename('fullpath');
FileSepIndex = strfind(Path,filesep);
cd(Path(1:FileSepIndex(end)));

%������Ի����ȡ����������

InputdlgOptions.Resize = 'on';
InputdlgOptions.WindowStyle = 'normal';

%����Ƿ�����һλ�������Ƶļ�¼
if exist('LastSubjectName.mat','file')
    %�������Ĭ�����ø���������(���޸�)
    load LastSubjectName.mat;
    SubjectName = inputdlg('Subject Name:','����������������',[1,42],{LastSubjectName},InputdlgOptions);
else
    %���û����Ĭ����������Ϊ'ABC'
    SubjectName = inputdlg('Subject Name:','����������������',[1,42],{'ABC'},InputdlgOptions);
end

%����Ի���û�з���ֵ����ʾ�����˳�����
if isempty(SubjectName)
    errordlg('�������Ʋ���Ϊ�գ�','��������');
    return;
end

%�洢���������������Ϊ����ʵ���������Ƶ�Ĭ��ֵ
LastSubjectName = SubjectName{1};

save LastSubjectName.mat LastSubjectName;

%��ȡ��ʵ�鿪ʼʱ��ĸ�ʽ�ַ���
DateString = datestr(now,'yyyymmdd_HH-MM-SS');


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

%���п����õ���mex�����Խ�ʡ��������ʱ��
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
    %%
    %����������
    
    %��˹��������������
    DataWhiteNoise = wgn(2,round(TimeWhiteNoise*AudioSampleRate),PowerWhiteNoise);
    %��һ�������ͷ���(�����������������)
    DataWhiteNoise = DataWhiteNoise/max(abs(DataWhiteNoise(:)))*0.6;
    
    %���뵭�������ҹ��ɷ��ȵ��ƣ�
    
    %���뵭����������
    NumPointFadeIn = 1000;
    NumPointFadeOut = 1000;
    
    t = (-1*round(NumPointFadeIn):-1)/AudioSampleRate;
    
    %���㽥����ȵ������Һ�����Ƶ��
    FreqFadeIn = AudioSampleRate/(2*NumPointFadeIn);
    
    %���㽥����ȵ������Һ����ķ���
    AmpFadeIn = (cos(2*pi*FreqFadeIn*t)+1)/2;
    
    t = (1:round(NumPointFadeOut))/AudioSampleRate;
    
    %���㽥�����ȵ������Һ�����Ƶ��
    FreqFadeOut = AudioSampleRate/(2*NumPointFadeOut);
    %���㽥�����ȵ������Һ����ķ���
    AmpFadeOut = (cos(2*pi*FreqFadeOut*t)+1)/2;
    
    %�����ҷ��ȵ��ƺ����Ͱ�������ͷ�ͽ�β���������
    DataWhiteNoise(:,1:NumPointFadeIn)=DataWhiteNoise(:,1:NumPointFadeIn).*repmat(AmpFadeIn,2,1);
    
    DataWhiteNoise(:,end-NumPointFadeIn+1:end)=DataWhiteNoise(:,end-NumPointFadeIn+1:end).*repmat(AmpFadeOut,2,1);
    
    %�½�һ��buffer���ڴ�Ű���������
    HandleWhiteNoiseBuffer = PsychPortAudio('CreateBuffer',HandlePortAudio,...
        [zeros(2,round(TimeGapSilence*AudioSampleRate)),DataWhiteNoise,zeros(2,round(TimeGapSilence*AudioSampleRate))]);
    
    
    
    %%
    %������ʾ��
    
    %������ʾ��(������������)����
    
    t = linspace(0,TimeHintSound/6,round(TimeHintSound/6*AudioSampleRate));
    DataHintSound =  0.5*sin(2*pi*FreqHintSound*t);
    
    %���뵭����������
    NumPointFadeIn = 8000;
    NumPointFadeOut = 8000;
    
    t = (-1*round(NumPointFadeIn):-1)/AudioSampleRate;
    %���㽥����ȵ������Һ�����Ƶ��
    FreqFadeIn = AudioSampleRate/(2*NumPointFadeIn);
    %���㽥����ȵ������Һ����ķ���
    AmpFadeIn = (cos(2*pi*FreqFadeIn*t)+1)/2;
    
    t = (1:round(NumPointFadeOut))/AudioSampleRate;
    %���㽥�����ȵ������Һ�����Ƶ��
    FreqFadeOut = AudioSampleRate/(2*NumPointFadeOut);
    %���㽥�����ȵ������Һ����ķ���
    AmpFadeOut = (cos(2*pi*FreqFadeOut*t)+1)/2;
    
    %�����ҷ��ȵ��ƺ�������ʾ����ͷ�ͽ�β���������
    DataHintSound(:,1:NumPointFadeIn)=DataHintSound(:,1:NumPointFadeIn).*AmpFadeIn;
    
    DataHintSound(:,end-NumPointFadeIn+1:end)=DataHintSound(:,end-NumPointFadeIn+1:end).*AmpFadeOut;
    
    
    DataHintSound = repmat([DataHintSound,zeros(1,TimeHintSound/6*AudioSampleRate)],1,3);
    
    PsychPortAudio('Stop', HandlePortAudio);
    
    %����ʾ����䵽PortAudio�����Buffer��
    PsychPortAudio('FillBuffer', HandlePortAudio,repmat(DataHintSound,2,1));
    %������ʾ��
    PsychPortAudio('Start', HandlePortAudio, 1, AudioStartTime, WaitUntilDeviceStart);
    
    %�ȴ��������룬��ʾ����������Զ������ȴ�
    [~, KeyCode,~] = KbWait([],0,GetSecs+TimeHintSound);
    %���Esc��������
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
    
    %ֹͣ��ʾ������
    PsychPortAudio('Stop', HandlePortAudio);
    
    %��ȡ��ǰRun��ͼ������
    iPattern = MatrixPattern(NumUsedRow+1,:);
    %��iTrial����ֵ����
    iTrial = 0;
    
    %         %���ڱ��251��ʾʵ�鿪ʼ
    %         lptwrite(LptAddress,251);
    %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
    %         WaitSecs(0.1);
    %         %��������0
    %         lptwrite(LptAddress,0);
    
    
    %���е�һ��Flip�Ի�ȡ��ǰʱ��
    vbl = Screen('Flip', PointerWindow);
    
    while  iTrial < NumTrial
        %Trial��������һ
        iTrial = iTrial + 1;
        %����һ��Trial���߱���ͼ�����ϴβ�ͬʱ�Ŷ�ȡ������ͼ���Ļ�ͼ����
        if iTrial == 1 ||(iTrial >1 && iPattern(iTrial-1) ~= iPattern(iTrial))
            eval(['Pattern',num2str(iPattern(iTrial))]);
            eval(['load Sound',num2str(iPattern(iTrial)),'.mat']);
        end
        
        %����������PortAudio�����Buffer��
        PsychPortAudio('FillBuffer', HandlePortAudio,HandleWhiteNoiseBuffer);
        %��������
        PsychPortAudio('Start', HandlePortAudio, 1, AudioStartTime, WaitUntilDeviceStart);
        
        %         %���ڱ��250��ʾ��ʼTrial��ʼ(����->��˹->����->��������->����->��������->����...)
        %         lptwrite(LptAddress,250);
        %         %������״̬����һ��ʱ�䣨ʱ��������NeuroScan�Ĳ���ʱ������
        %         WaitSecs(0.1);
        %         %��������0
        %         lptwrite(LptAddress,0);
        
        %�ȴ���������
        [~, KeyCode,~] = KbWait([],0,GetSecs+TimeWhiteNoise+2*TimeGapSilence-0.1);
        %���Esc��������
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
            %����ո������������ת����һ��ͼ��
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
            %������һ��whileѭ��
            continue;
        end
        
        
        %�������������ݵ�PortAudio�����Buffer��
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
        
        
        %�ȴ�ֱ��ESC�������£��˳�ʵ�飩���߿ո�������£���ת����һ��ͼ����
        [~, KeyCode,~] = KbWait([],0);
        %���ESC��������
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
            %����ո��������
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
            %������һ��whileѭ��
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
    %���·�����������½���Ӧ��·��
    if ~exist(RecordPath,'dir')
        mkdir(RecordPath);
    end
    %��¼�ļ���
    RecordFile = [RecordPath,filesep,DateString,'.mat'];
    
    Run = NumUsedRow + 1;
    %�洢�ı���
    save(RecordFile,'iPattern','Run');
    
    %�����Ѿ�����Run����MatrixPattern.m���в���
    NumUsedRow = NumUsedRow + 1;
    
    %���MatrixPattern�Ѿ�������
    if NumUsedRow >=NumRun
        %ɾ��MatrixPattern.m
        delete MatrixPattern.m;
        
    else
        %�������MatrixPattern.m�е�NumUsedRow
        save MatrixPattern.m MatrixPattern  NumUsedRow;
    end
    
    clear MatrixPattern NumUsedRow;
    
    %�ָ�Matlab�����д��ڶԼ����������Ӧ
    ListenChar(0);
    %�ָ�KbCheck���������м����������Ӧ
    RestrictKeysForKbCheck([]);
    %�ر�PsychPortAudio
    PsychPortAudio('Close');
    %�ر�����Psych����
    sca;
    
    
    %%
    %�������ִ�г�����ִ���������
catch Error
    %�ر�PsychPortAudio
    PsychPortAudio('Close');
    %�ر�����Psych����
    sca;
    %�ָ�Matlab�����д��ڶԼ����������Ӧ
    ListenChar(0);
    %�ָ�KbCheck���������м����������Ӧ
    RestrictKeysForKbCheck([]);
    
    %�������������������
    rethrow(Error);
    
end
