%此程序为训练程序
%软件环境：
%Psychtoolbox:3.0.12
%Matlab:R2015a x64
%Windows 8.1 x64

%%
% close all;
% clear;
% sca;

%修改工作路径至当前M文件所在目录
Path=mfilename('fullpath');
FileSepIndex = strfind(Path,filesep);
cd(Path(1:FileSepIndex(end)));

%%
%显示部分设置
%执行默认设置2
%相当于执行了以下三条语句：
%“AssertOpenGL;” 确保Screen函数被正确安装
%“KbName('UnifyKeyNames');” 设置一套适用于所有操作系统的统一的KeyCode（按键码）和KeyName（按键名）对(MacOS-X),使用“ KbName('KeyNamesOSX')”查看
%在创建窗口后立刻执行“Screen('ColorRange', PointerWindow, 1, [],1);”将颜色的设定方式由3个8位无符号整数组成的三维向量改成3个0到1的浮点数三维向量，目的是为了同时兼容不同颜色位数的显示器（比如8位和16位显示器）
PsychDefaultSetup(2);

%键盘响应设置
%Matlab命令行窗口停止响应键盘字符输入（按Crtl+C可以取消这一状态）
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
    
%     %调用ExpTrain_ParameterSetting.m设置相应参数
%     ExpTrain_ParameterSetting;
    %     %字体和大小设定
%     Screen('TextFont', PointerWindow, NameFont);
%     Screen('TextSize', PointerWindow ,SizeFont);

    %设置Alpha-Blending相应参数
    Screen('BlendFunction', PointerWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    %等待帧数设定，后面用于保证准确的帧刷新时序
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
%如果程序执行出错则执行下面程序
catch Error
    
    sca;
    rethrow(Error);
    
end
