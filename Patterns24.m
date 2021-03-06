%Pattern22
SizeScreenX = 1600;
SizeScreenY = 900;
PenWidth = 20;
white = 1;
black = 0;
FramePerSecond = 60;

SizeCanvas = round(SizeScreenY/5*3);
OriginX = round((SizeScreenX - SizeCanvas)/2);
OriginY = SizeCanvas + round((SizeScreenY - SizeCanvas)/2);
PatternVertex =...
    [0.5,0.9;
     0.5,0.5;
     0.5,0.1;];
 
PatternVertex(:,1) = round(OriginX + PatternVertex(:,1)*SizeCanvas);
PatternVertex(:,2) = round(OriginY - PatternVertex(:,2)*SizeCanvas);



NumArc = [1,2];
ColorPolygon = white;


SegLength = [0.2*pi,0.2*pi];
SegFrame= zeros(size(SegLength));
SumTime = 3;
SegTime = SegLength/sum(SegLength)*SumTime;

SumFrame = round(SumTime*FramePerSecond);
SegFrame(1:end-1) = round(SegTime(1:end-1)*FramePerSecond);
SegFrame(end) = SumFrame - sum(SegFrame(1:end-1));

RadiusOut = round(0.2*SizeCanvas + PenWidth/2);

RadiusIn =  round(0.2*SizeCanvas - PenWidth/2);

ColorRoundIn = black;
ColorRoundOut = white;

ArcAngle = {zeros(NumArc(1),SegFrame(1)),zeros(NumArc(2),SegFrame(2))};
RectRoundIn = {zeros(NumArc(1),4),zeros(NumArc(2),4)};
RectRoundOut = {zeros(NumArc(1),4),zeros(NumArc(2),4)};

iSeg = 1;
%��һ��

if NumArc(iSeg) >1
    
    ArcAngle{iSeg}(1:NumArc(iSeg-1),:) =  repmat(ArcAngle{iSeg-1}(1:NumArc(iSeg-1),end),1,SegFrame(iSeg));
    RectRoundIn{iSeg}(1:NumArc(iSeg-1),:) = RectRoundIn{iSeg-1}(1:NumArc(iSeg-1),:) ;
    RectRoundOut{iSeg}(1:NumArc(iSeg-1),:) = RectRoundOut{iSeg-1}(1:NumArc(iSeg-1),:) ;
 
end;
iArc = 1:NumArc(iSeg);
RoundCenterX = round((PatternVertex(iSeg,1)+PatternVertex(iSeg+1,1))/2);
RoundCenterY = round((PatternVertex(iSeg,2)+PatternVertex(iSeg+1,2))/2);

RectRoundIn{iSeg}(iArc,:) = [RoundCenterX- RadiusIn ,RoundCenterY- RadiusIn ,...
    RoundCenterX+ RadiusIn ,RoundCenterY + RadiusIn];
RectRoundOut{iSeg}(iArc,:) = [RoundCenterX- RadiusOut ,RoundCenterY- RadiusOut ,...
    RoundCenterX+ RadiusOut ,RoundCenterY + RadiusOut];

StartAngle(iSeg) = 0;
EndAngle(iSeg) = 180;

ArcAngle{iSeg}(iArc,:) = linspace(0,-1*abs(EndAngle(1)-StartAngle(1)),SegFrame(iSeg));


iSeg = iSeg +1 ;
%�ڶ���

if NumArc(iSeg) >1
    
    ArcAngle{iSeg}(1:NumArc(iSeg-1),:) =  repmat(ArcAngle{iSeg-1}(1:NumArc(iSeg-1),end),1,SegFrame(iSeg));
    RectRoundIn{iSeg}(1:NumArc(iSeg-1),:) = RectRoundIn{iSeg-1}(1:NumArc(iSeg-1),:) ;
    RectRoundOut{iSeg}(1:NumArc(iSeg-1),:) = RectRoundOut{iSeg-1}(1:NumArc(iSeg-1),:) ;
 
end;

iArc = NumArc(iSeg-1)+1:NumArc(iSeg);

RoundCenterX = round((PatternVertex(iSeg,1)+PatternVertex(iSeg+1,1))/2);
RoundCenterY = round((PatternVertex(iSeg,2)+PatternVertex(iSeg+1,2))/2);

RectRoundIn{iSeg}(iArc ,:) = [RoundCenterX- RadiusIn ,RoundCenterY- RadiusIn ,...
    RoundCenterX+ RadiusIn ,RoundCenterY + RadiusIn];
RectRoundOut{iSeg}(iArc ,:) = [RoundCenterX- RadiusOut ,RoundCenterY- RadiusOut ,...
    RoundCenterX+ RadiusOut ,RoundCenterY + RadiusOut];

StartAngle(iSeg) = 0;
EndAngle(iSeg) = 180;

ArcAngle{iSeg}(iArc,:) = linspace(0,abs(EndAngle(iSeg)-StartAngle(iSeg)),SegFrame(iSeg));

