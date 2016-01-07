%�˳���Ϊѵ������
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
    
    
    %���е�һ��Flip�Ի�ȡʱ��
    vbl = Screen('Flip', PointerWindow);
    
    PatternRangeMin = min(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    PatternRangeMax = max(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    
    
    [~, KeyCode,~] = KbWait([],0,GetSecs+TimeGapSilence);
    if KeyCode(KbName('ESCAPE'))
        %�ر�PortAudio����
        PsychPortAudio('Close');
        %�ָ�Matlab�����д��ڶԼ����������Ӧ
        ListenChar(0);
        %�ָ�KbCheck���������м����������Ӧ
        RestrictKeysForKbCheck([]);
        sca;
        %��ֹ����
        return;
    end
        
    
    
    FlagNext = true;
    iPattern = 0;
   
    while 1
        
        if FlagNext ==true
            iPatternTemp = iPattern;
            iPattern = randi([PatternRangeMin,PatternRangeMax]);
            FlagNext = false;

            if iPattern ~= iPatternTemp
                eval(['Pattern',num2str(iPattern)]);
                eval(['load Sound',num2str(iPattern),'.mat']);
            end
        
        PsychPortAudio('Stop', HandlePortAudio);
        
        %��䵽PortAudio�����Buffer��
        PsychPortAudio('FillBuffer', HandlePortAudio,[DataAudio,zeros(2,round(TimeGapSilence*AudioSampleRate))]);
        %��������
        PsychPortAudio('Start', HandlePortAudio, 0, AudioStartTime, WaitUntilDeviceStart);
        
        end
        

        %%
        if iPattern>=1 && iPattern<=16
            for iSeg =1:NumSeg
                
                if FlagNext == true
                    break;
                end
                
                for iFrame = 1:SegFrame(iSeg)
                    
                    for iPolygon = 1:NumPolygon(iSeg)
                        Screen('FillPoly',PointerWindow,white,PolygonVertex{iSeg}(:,2*iPolygon-1:2*iPolygon,iFrame),1);
                    end
                    
                    
                    Screen('DrawingFinished', PointerWindow);
                    vbl = Screen('Flip', PointerWindow, vbl + (FrameWait-0.5) * TimePerFlip);
                    %��ȡ�������룬��Esc���������������˳�����
                    [IsKeyDown,~,KeyCode] = KbCheck;
                    if IsKeyDown && KeyCode(KbName('ESCAPE'))
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
                    elseif IsKeyDown && KeyCode(KbName('space'))
                        
                        FlagNext = true;
                        
                        PsychPortAudio('Stop', HandlePortAudio);
                        %�ȴ��ո���ɿ�
                        KbWait([],1);
                        break;
                    end
                end
          
            end
            
        elseif iPattern>=17 && iPattern<=20
            for iSeg =1:NumSeg
                
                if FlagNext == true
                    break;
                end
                
                for iFrame = 1:SegFrame(iSeg)
                    
                    if iSeg == NumSeg
                        Screen('FillArc',PointerWindow,ColorRoundOut,RectRoundOut,StartAngle,ArcAngle(iFrame));
                        Screen('FillArc',PointerWindow,ColorRoundIn,RectRoundIn,StartAngle,ArcAngle(iFrame));
                    end
                    
                    for iPolygon = 1:NumPolygon(iSeg)
                        Screen('FillPoly',PointerWindow,white,PolygonVertex{iSeg}(:,2*iPolygon-1:2*iPolygon,iFrame),1);
                    end
                    
                    
                    Screen('DrawingFinished', PointerWindow);
                    vbl = Screen('Flip', PointerWindow, vbl + (FrameWait-0.5) * TimePerFlip);
                    %��ȡ�������룬��Esc���������������˳�����
                    [IsKeyDown,~,KeyCode] = KbCheck;
                    if IsKeyDown && KeyCode(KbName('ESCAPE'))
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
                    elseif IsKeyDown && KeyCode(KbName('space'))
                        
                        FlagNext = true;
                        
                        PsychPortAudio('Stop', HandlePortAudio);
                        %�ȴ��ո���ɿ�
                        KbWait([],1);
                        break;
                        
                    end
                end
            end
            
        elseif iPattern>=21 && iPattern<=24
            
            for iSeg = 1:NumSeg
                
                if FlagNext == true
                    break;
                end
                
                for iFrame = 1:SegFrame(iSeg)
                    
                    for iArc = 1:NumArc(iSeg)
                        
                        Screen('FillArc',PointerWindow,ColorRoundOut,RectRoundOut{iSeg}(iArc,:),StartAngle(iSeg),ArcAngle{iSeg}(iArc,iFrame));
                        Screen('FillArc',PointerWindow,ColorRoundIn,RectRoundIn{iSeg}(iArc,:),StartAngle(iSeg),ArcAngle{iSeg}(iArc,iFrame));
                        
                    end
                    
                    
                    Screen('DrawingFinished', PointerWindow);
                    vbl = Screen('Flip', PointerWindow, vbl + (FrameWait-0.5) * TimePerFlip);
                    
                    %��ȡ�������룬��Esc���������������˳�����
                    [IsKeyDown,~,KeyCode] = KbCheck;
                    if IsKeyDown && KeyCode(KbName('ESCAPE'))
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
                    elseif IsKeyDown && KeyCode(KbName('space'))
                        
                        FlagNext = true;
                        PsychPortAudio('Stop', HandlePortAudio);
                        %�ȴ��ո���ɿ�
                        KbWait([],1);
                       
                        break;
                        
                    end
                end
            end

        end
        
        if FlagNext == false
            
            [~, KeyCode,~] = KbWait([],0,GetSecs+TimeGapSilence);
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
            elseif  KeyCode(KbName('space'))
                FlagNext = true;
                PsychPortAudio('Stop', HandlePortAudio);
                %�ȴ��ո���ɿ�
                KbWait([],1);
            end
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
