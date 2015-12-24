clear;
%Sound of |_|
MelMin =  100;
MelMax = 1500;

AudioSampleRate = 48000;

LengthSum = 2.4;
TimeSum = 3;

CoefLen2Time = TimeSum/LengthSum;

NumSumPoint = round(TimeSum*AudioSampleRate);


x = zeros(1,NumSumPoint);

y = zeros(1,NumSumPoint);


NumSeg = 3;

LengthSeg = zeros(1,NumSeg);

TimeSeg = zeros(1,NumSeg);

NumSegPoint = zeros(1,NumSeg);

SegStartX = zeros(1,NumSeg);

SegEndX = zeros(1,NumSeg);

SegStartY = zeros(1,NumSeg);

SegEndY = zeros(1,NumSeg);

SegStartPoint = zeros(1,NumSeg);


iSeg = 1;
SegStartPoint(iSeg) = 1;

%段1 |
LengthSeg(iSeg) = LengthSum/3;


TimeSeg(iSeg) = LengthSeg(iSeg) * CoefLen2Time;

NumSegPoint(iSeg) = round(TimeSeg(iSeg) *AudioSampleRate);

SegStartPoint(iSeg +1) = SegStartPoint(iSeg) + NumSegPoint(iSeg);

SegStartX(iSeg) =  0.5 - LengthSeg(iSeg)/2 ;
SegStartY(iSeg) =  0.5 + LengthSeg(iSeg)/2 ;

SegEndX(iSeg) =  0.5 - LengthSeg(iSeg)/2 ;
SegEndY(iSeg) =  0.5 - LengthSeg(iSeg)/2 ;

x(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = linspace(SegStartX(iSeg),SegEndX(iSeg),NumSegPoint(iSeg));

y(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = linspace(SegStartY(iSeg),SegEndY(iSeg),NumSegPoint(iSeg));

iSeg = iSeg + 1;
%段2 -
LengthSeg(iSeg) = LengthSum/3;


TimeSeg(iSeg) = LengthSeg(iSeg) * CoefLen2Time;

NumSegPoint(iSeg) = round(TimeSeg(iSeg) *AudioSampleRate);

SegStartPoint(iSeg +1) = SegStartPoint(iSeg) + NumSegPoint(iSeg);

SegStartX(iSeg) =  0.5 - LengthSeg(iSeg)/2 ;
SegStartY(iSeg) =  0.5 - LengthSeg(iSeg)/2 ;

SegEndX(iSeg) =  0.5 + LengthSeg(iSeg)/2 ;
SegEndY(iSeg) =  0.5 - LengthSeg(iSeg)/2 ;

x(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = linspace(SegStartX(iSeg),SegEndX(iSeg),NumSegPoint(iSeg));

y(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = linspace(SegStartY(iSeg),SegEndY(iSeg),NumSegPoint(iSeg));



iSeg = iSeg + 1;
%段3 |
LengthSeg(iSeg) = LengthSum/3;


TimeSeg(iSeg) = LengthSeg(iSeg) * CoefLen2Time;

NumSegPoint(iSeg) = round(TimeSeg(iSeg) *AudioSampleRate);


SegStartX(iSeg) =  0.5 + LengthSeg(iSeg)/2 ;
SegStartY(iSeg) =  0.5 - LengthSeg(iSeg)/2 ;

SegEndX(iSeg) =  0.5 + LengthSeg(iSeg)/2 ;
SegEndY(iSeg) =  0.5 + LengthSeg(iSeg)/2 ;

x(SegStartPoint(iSeg):NumSumPoint) = linspace(SegStartX(iSeg),SegEndX(iSeg),NumSegPoint(iSeg));

y(SegStartPoint(iSeg):NumSumPoint) = linspace(SegStartY(iSeg),SegEndY(iSeg),NumSegPoint(iSeg));

t = linspace(0,TimeSum,NumSumPoint);

mel = MelMin+y*(MelMax - MelMin);

f = 700*exp(mel/1127-1);

AmpR = x;

AmpL = 1-x;

DataAudio = [AmpL;AmpR].*repmat(cos(2*pi*f.*t),2,1);




DataAudio(:,SegPoint(iSeg):SegPoint(iSeg) + EndPoint-1) = DataTemp(:,1:EndPoint);

SegPoint(iSeg+1) = SegPoint(iSeg) + EndPoint;

iSeg = iSeg + 1;

%段2 _
LengthSeg = LengthSum/3;

TimeSeg = LengthSeg * CoefLen2Time;

NumSegPoint = round(TimeSeg * AudioSampleRate);

StartX =  0.5 - LengthSeg/2 ;
StartY =  0.5 - LengthSeg/2 ;

EndX =  0.5 + LengthSeg/2 ;
EndY =  0.5 - LengthSeg/2 ;


MelAll = MelMin+StartY*(MelMax - MelMin);

FreqAll = 700*exp(MelAll/1127-1);


t = (0:NumSegPoint+NumPadPoint)/AudioSampleRate;

DataTemp = cos(2*pi*FreqAll*t);

iPoint = 2:NumSegPoint+NumPadPoint;

PeakIndex = [true,DataTemp(iPoint) >= DataTemp(iPoint-1) & DataTemp(iPoint) >= DataTemp(iPoint+1)];

PeakIndex = find(PeakIndex)-1;

[~,EndPointIndex] = min(abs(PeakIndex-NumSegPoint));
EndPoint = PeakIndex(EndPointIndex);

AmpR = linspace(StartX,EndX,EndPoint);

AmpL = 1 - AmpR;


DataTemp = repmat(DataTemp(1:EndPoint),2,1).*[AmpL;AmpR];

DataAudio(:,SegPoint(iSeg):SegPoint(iSeg) + size(DataTemp,2)-1) = DataTemp;

SegPoint(iSeg+1) = SegPoint(iSeg) + size(DataTemp,2);

iSeg = iSeg + 1;


%段3  |
LengthSeg = LengthSum/3;

TimeSeg = LengthSeg * CoefLen2Time;

StartX = 0.5 + LengthSeg/2;
StartY = 0.5 - LengthSeg/2;

EndX = 0.5 + LengthSeg/2;
EndY = 0.5 + LengthSeg/2;

AmpR =  StartX;
AmpL = 1 - AmpR;

DataTemp = zeros(2,SegPoint(2)-SegPoint(1));
DataTemp(1,:) = DataAudio(1,SegPoint(2)-1:-1:SegPoint(1))/(max(abs(DataAudio(1,SegPoint(2)-1:-1:SegPoint(1)))))*AmpL;
DataTemp(2,:) = DataAudio(2,SegPoint(2)-1:-1:SegPoint(1))/(max(abs(DataAudio(2,SegPoint(2)-1:-1:SegPoint(1)))))*AmpR;

DataAudio(:,SegPoint(iSeg):SegPoint(iSeg) + size(DataTemp,2)-1) = DataTemp;

%调整长度
NumPointError = NumSumPoint- (SegPoint(iSeg) + size(DataTemp,2)-1);

if NumPointError<0
    NumPointError = abs(NumPointError);
    if mod (NumPointError,2)==1
        DataAudio = DataAudio(:,ceil(NumPointError/2)+1:end-fix(NumPointError/2));
    else
        DataAudio = DataAudio(:,NumPointError/2+1:end-NumPointError/2);
    end
elseif NumPointError>0
    
     if mod (NumPointError,2)==1
        DataAudio = [zeros(2,ceil(NumPointError/2)),DataAudio,zeros(2,fix(NumPointError/2))];
    else
        DataAudio = [zeros(2,NumPointError/2),DataAudio,zeros(2,NumPointError/2)];
    end
 
end



%淡入淡出
NumPointFadeIn = 1000;

NumPointFadeOut = 1000;

t = (-1*round(NumPointFadeIn):-1)/AudioSampleRate;

f = AudioSampleRate/(2*NumPointFadeIn);

AmpFadeIn = (cos(2*pi*f*t)+1)/2;

t = (1:round(NumPointFadeOut))/AudioSampleRate;

f = AudioSampleRate/(2*NumPointFadeOut);

AmpFadeOut = (cos(2*pi*f*t)+1)/2;


DataAudio(:,1:NumPointFadeIn)=DataAudio(:,1:NumPointFadeIn).*repmat(AmpFadeIn,2,1);


DataAudio(:,end-NumPointFadeIn+1:end)=DataAudio(:,end-NumPointFadeIn+1:end).*repmat(AmpFadeOut,2,1);

save Sound1.mat DataAudio AudioSampleRate;


sound(DataAudio,AudioSampleRate);
