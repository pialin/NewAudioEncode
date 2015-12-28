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
ListenChar(2);

%����KbCheck��Ӧ�İ�����Χ��ֻ��Esc��space�����Դ���KbCheck��
RestrictKeysForKbCheck(KbName('ESCAPE','space'));


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
    
    %����ExpTrain_ParameterSetting.m������Ӧ����
    ExpTrain_ParameterSetting;
    
    %����ʹ�С�趨
    Screen('TextFont', PointerWindow, NameFont);
    Screen('TextSize', PointerWindow ,SizeFont);
    %����Alpha-Blending��Ӧ����
    Screen('BlendFunction', PointerWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    %�ȴ�֡���趨���������ڱ�֤׼ȷ��֡ˢ��ʱ��
    FrameWait = 1;
    
    OriginX = round((SizeScreenX - SizeCanvas)/2);
    OriginY = SizeCanvas + round((SizeScreenY - SizeCanvas)/2);
    
    
    SeqPointX = OriginX + round(SeqPointX*SizeCanvas);
    SeqPointY = OriginY - round(SeqPointY*SizeCanvas);
    
    RectLine = zeros(4,NumSeg);
    
    for iSeg = 1:NumSeg
        
        for iFrame  = 1:Time(iSeg)
            
            RectLine(1,iSeg) = OriginX + round(SeqPointX(SegStartPoint(iSeg))*SizeCanvas-LineWidth/2) ;
            RectLine(2,iSeg) = OriginY - round(SeqPointX(SegStartPoint(iSeg))*SizeCanvas-LineWidth/2) ;
            
            RectLine(3,iSeg) = ...
                round((SeqPointX(SegStartPoint(iSeg)+iFrame)-SeqPointX(SegStartPoint(iSeg)))*SizeCanvas+LineWidth/2) ;
            RectLine(4,iSeg) = ...
            round((SeqPointX(SegStartPoint(iSeg)+iFrame)-SeqPointX(SegStartPoint(iSeg)))*SizeCanvas+LineWidth/2) ;
            
        end
        
    end
    
    
    
    
    
    
    
    
    
    
%%
%�������ִ�г�����ִ���������
catch Error
    
end
