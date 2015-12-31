%Pattern21
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
    [0.1,0.5;
     0.5,0.5;
     0.9,0.5;];
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


iSeg = 1;
%第一段
RoundCenterX(1) = round(OriginX + 0.3*SizeCanvas);
RoundCenterY(1) = round(OriginY - 0.5*SizeCanvas);

RectRoundIn(1,:) = [RoundCenterX(1)- RadiusIn ,RoundCenterY(1)- RadiusIn ,...
    RoundCenterX(1)+ RadiusIn ,RoundCenterY(1) + RadiusIn];
RectRoundOut(1,:) = [RoundCenterX(1)- RadiusOut ,RoundCenterY(1)- RadiusOut ,...
    RoundCenterX(iSeg)+ RadiusOut ,RoundCenterY(1) + RadiusOut];

StartAngle(1) = -90;
EndAngle(1) = 90;

ArcAngle{iSeg}(1,:) = linspace(0,abs(EndAngle(1)-StartAngle(1)),SegFrame(iSeg));


iSeg = iSeg +1 ;
%第二段
RoundCenterX(2) =  round(OriginX + 0.7*SizeCanvas);
RoundCenterY(2) = round(OriginY - 0.5*SizeCanvas);

RectRoundIn(2,:) = [RoundCenterX(2)- RadiusIn ,RoundCenterY(2)- RadiusIn ,...
    RoundCenterX(2)+ RadiusIn ,RoundCenterY(2) + RadiusIn];
RectRoundOut(2,:) = [RoundCenterX(2)- RadiusOut ,RoundCenterY(2)- RadiusOut ,...
    RoundCenterX(2)+ RadiusOut ,RoundCenterY(2) + RadiusOut];

StartAngle(2) = -90;
EndAngle(2) = 90;

if iSeg >1
    ArcAngle{iSeg}(1,:) =  repmat(ArcAngle{iSeg-1}(1,end),1,SegFrame(iSeg));
end

ArcAngle{iSeg}(2,:) = linspace(0,-1*abs(EndAngle(2)-StartAngle(2)),SegFrame(iSeg));




























