clear;
%Sound of "]"
MelMin =  100;
MelMax = 1500;

AudioSampleRate = 48000;

LengthSum = 2.4;
TimeSum = 3;

CoefLen2Time = TimeSum/LengthSum;

NumPointSum = round(TimeSum*AudioSampleRate);

GapWidth = 0.01;

FreqMin = 700*exp(MelMin/1127-1);
NumPadPoint = ceil (1/FreqMin * AudioSampleRate);

CurrentPoint = 0;

%段1 —
LengthSeg = 0.8;

TimeSeg = TimeSum/3;

NumSegPoint = round(TimeSeg* AudioSampleRate);


StartX =  0.5 - LengthSeg/2 ;
StartY =  0.5 + LengthSeg/2 ;

EndX =  0.5 + LengthSeg/2 ;
EndY =  0.5 + LengthSeg/2 ;


MelAll = MelMin+StartY*(MelMax - MelMin);

FreqAll = 700*exp(MelAll/1127-1);


t = (0:NumSegPoint+NumPadPoint)/AudioSampleRate;

TempData = cos(2*pi*FreqAll*t);

iPoint = 2:NumSegPoint+NumPadPoint-1;

PeakIndex = [true,TempData(iPoint)>= TempData(iPoint-1) & TempData(iPoint)>= TempData(iPoint+1)];

PeakIndex = find(PeakIndex);

[~,EndPointIndex] = min(abs(PeakIndex-NumSegPoint));
EndPoint = PeakIndex(EndPointIndex);

SeqRightAmp = linspace(StartX,EndX,EndPoint);

SeqLeftAmp = 1 - SeqRightAmp;


TempData = TempData(1:EndPoint);

DataAudio1 = [TempData(1:EndPoint).*SeqLeftAmp;TempData(1:EndPoint).*SeqRightAmp];





%段2 |
LengthSeg = 0.8;


TimeSeg = LengthSeg * CoefLen2Time;

NumSegPoint = round(TimeSeg *AudioSampleRate);



StartX =  0.5 + LengthSeg/2 ;
StartY =  0.5 + LengthSeg/2 ;

EndX =  0.5 + LengthSeg/2 ;
EndY =  0.5 - LengthSeg/2 ;

NumDot = ceil(LengthSeg/GapWidth) + 1;

SeqX = ones(1,NumDot)*StartX ;

if StartY <= EndY
    
    SeqY = StartY:GapWidth:EndY;  
    
else
    
    SeqY = StartY:-1*GapWidth:EndY;
    
end

if floor(LengthSeg/GapWidth) ~= ceil(LengthSeg/GapWidth)
    
    SeqY = [SeqY,EndY];
    
end

SeqNumDotPoint = round(abs(SeqY(1:end-1)- SeqY(2:end))*CoefLen2Time*AudioSampleRate);


SeqMel = MelMin+SeqY*(MelMax - MelMin);

SeqFreq = 700*exp(SeqMel/1127-1);

SeqRightAmp = SeqX;

DataAudio2 =zeros(2,ceil(TimeSeg*AudioSampleRate));


for iDot = 1:NumDot - 1
    
    DataChirp = chirp((0:SeqNumDotPoint(iDot)+NumPadPoint)/AudioSampleRate,SeqFreq(iDot),(SeqNumDotPoint(iDot)-1)/AudioSampleRate,SeqFreq(iDot+1),'logarithmic');
    
    EndPoint = SeqNumDotPoint(iDot);
    
    if mod(iDot,2) == 0 %偶数段结尾截短至1

        while DataChirp(EndPoint)~= max(DataChirp(EndPoint-1:EndPoint+1))
            
            EndPoint = EndPoint - 1;
        end

    elseif mod(iDot,2) == 1 %奇数段结尾延长至1
        
   
        while DataChirp(EndPoint)~= max(DataChirp(EndPoint-1:EndPoint+1))
            
            EndPoint = EndPoint + 1;
        end
   
    end
    
    
    AmpRight = linspace(SeqRightAmp(iDot),SeqRightAmp(iDot+1),EndPoint);
    AmpLeft = 1 - AmpRight;
    
    DataAudio2(1,CurrentPoint+1:CurrentPoint+EndPoint) = DataChirp(1:EndPoint).*AmpLeft;
    DataAudio2(2,CurrentPoint+1:CurrentPoint+EndPoint) = DataChirp(1:EndPoint).*AmpRight;
    
    CurrentPoint = CurrentPoint+EndPoint;

end



%增删Seg数据
NumPointError = NumSegPoint - CurrentPoint;

iPoint = 2:CurrentPoint-1;

PeakIndex = [true,DataAudio2(1,iPoint)>= DataAudio2(1,iPoint-1) & DataAudio2(1,iPoint)>= DataAudio2(1,iPoint+1),true];

PeakIndex = find(PeakIndex);


if NumPointError <0
    
    [~,StartPointIndex] = min(abs(PeakIndex-abs(NumPointError/2)));
    [~,EndPointIndex] = min(abs(CurrentPoint-PeakIndex-abs(NumPointError/2)));
    
    StartPoint = PeakIndex(StartPointIndex);
    
    EndPoint = PeakIndex(EndPointIndex);
    
    DataAudio2 = DataAudio2(:,StartPoint:EndPoint);
    
elseif NumPointError >0
    
    NumStartPadCycle = round(NumPointError/2/(PeakIndex(2)-1));
    
    DataStartPad = repmat(DataAudio2(:,1:(PeakIndex(2)-1)),1,NumStartPadCycle);
    
    NumEndPadCycle = round(NumPointError/2/(CurrentPoint-PeakIndex(end-1)));
    
    DataEndPad = repmat(DataAudio2(:,(PeakIndex(end-1)+1):CurrentPoint),1,NumEndPadCycle);
    
    DataAudio2 = [DataStartPad,DataAudio2(:,1:CurrentPoint),DataEndPad];
 
end



%段3  _
LengthSeg = 0.8;

TimeSeg = TimeSum/3;

NumSegPoint = round(TimeSeg* AudioSampleRate);


StartX =  0.5 + LengthSeg/2 ;
StartY =  0.5 - LengthSeg/2 ;

EndX =  0.5 - LengthSeg/2 ;
EndY =  0.5 - LengthSeg/2 ;


MelAll = MelMin+StartY*(MelMax - MelMin);

FreqAll = 700*exp(MelAll/1127-1);


t = (0:NumSegPoint+NumPadPoint)/AudioSampleRate;

TempData = cos(2*pi*FreqAll*t);

iPoint = 2:NumSegPoint+NumPadPoint-1;

PeakIndex = [true,TempData(iPoint)>= TempData(iPoint-1) & TempData(iPoint)>= TempData(iPoint+1)];

PeakIndex = find(PeakIndex);

[~,EndPointIndex] = min(abs(PeakIndex-NumSegPoint));
EndPoint = PeakIndex(EndPointIndex);

SeqRightAmp = linspace(StartX,EndX,EndPoint);

SeqLeftAmp = 1 - SeqRightAmp;


TempData = TempData(1:EndPoint);

DataAudio3 = [TempData(1:EndPoint).*SeqLeftAmp;TempData(1:EndPoint).*SeqRightAmp];

%组合
DataAudio = [DataAudio1,DataAudio2,DataAudio3];

NumPointError = NumPointSum- size(DataAudio,2);

if NumPointError<0
    NumPointError = -1* NumPointError;
    if mod (NumPointError-NumPointSum,2)==1
        DataAudio = DataAudio(:,ceil(NumPointError/2)+1:end-fix(NumPointError/2));
    else
        DataAudio = DataAudio(:,NumPointError/2+1:end-NumPointError/2);
    end
elseif NumPointError>0
    
     if mod (NumPointError-NumPointSum,2)==1
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

save Sound3.mat DataAudio AudioSampleRate;


sound(DataAudio,AudioSampleRate);
