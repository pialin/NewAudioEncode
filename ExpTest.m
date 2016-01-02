%�˳���Ϊѵ������
%���������
%Psychtoolbox:3.0.12
%Matlab:R2015a x64
%Windows 8.1 x64

%%
% close all;
% clear;
% sca;

%�޸Ĺ���·������ǰM�ļ�����Ŀ¼
Path=mfilename('fullpath');
FileSepIndex = strfind(Path,filesep);
cd(Path(1:FileSepIndex(end)));

%%
%��ʾ��������
%ִ��Ĭ������2
%�൱��ִ��������������䣺
%��AssertOpenGL;�� ȷ��Screen��������ȷ��װ
%��KbName('UnifyKeyNames');�� ����һ�����������в���ϵͳ��ͳһ��KeyCode�������룩��KeyName������������(MacOS-X),ʹ�á� KbName('KeyNamesOSX')���鿴
%�ڴ������ں�����ִ�С�Screen('ColorRange', PointerWindow, 1, [],1);������ɫ���趨��ʽ��3��8λ�޷���������ɵ���ά�����ĳ�3��0��1�ĸ�������ά������Ŀ����Ϊ��ͬʱ���ݲ�ͬ��ɫλ������ʾ��������8λ��16λ��ʾ����
PsychDefaultSetup(2);

%������Ӧ����
%Matlab�����д���ֹͣ��Ӧ�����ַ����루��Crtl+C����ȡ����һ״̬��
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
    
%     %����ExpTrain_ParameterSetting.m������Ӧ����
%     ExpTrain_ParameterSetting;
    %     %����ʹ�С�趨
%     Screen('TextFont', PointerWindow, NameFont);
%     Screen('TextSize', PointerWindow ,SizeFont);

    %����Alpha-Blending��Ӧ����
    Screen('BlendFunction', PointerWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    %�ȴ�֡���趨���������ڱ�֤׼ȷ��֡ˢ��ʱ��
    FrameWait = 1;
   
    
    vbl = Screen('Flip', PointerWindow);
    
%     for iSeg =1:2
%         
%         for iFrame = 1:SegFrame(iSeg)
%             
%             for iArc = 1:NumArc(iSeg)
%                 
%                 Screen('FillArc',PointerWindow,ColorRoundOut,RectRoundOut(iArc,:),StartAngle(iArc),ArcAngle{iSeg}(iArc,iFrame));
%                 Screen('FillArc',PointerWindow,ColorRoundIn,RectRoundIn(iArc,:),StartAngle(iArc),ArcAngle{iSeg}(iArc,iFrame));
%                 
%             end
%            
%             
%             vbl = Screen('Flip', PointerWindow, vbl + (FrameWait-0.5) * TimePerFlip);
%         end
%         
%     end

for iSeg =1:3
    for iFrame = 1:SegFrame(iSeg)
        for iPolygon = 1:NumPolygon(iSeg)
            Screen('FillPoly',PointerWindow,white,PolygonVertex{iSeg}(:,2*iPolygon-1:2*iPolygon,iFrame),1);
        end
        vbl = Screen('Flip', PointerWindow, vbl + (FrameWait-0.5) * TimePerFlip);
    end
end



WaitSecs(2);
sca;

    
%%
%�������ִ�г�����ִ���������
catch Error
    
    sca;
    rethrow(Error);
    
end
