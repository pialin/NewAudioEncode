clear;
%Sound of |_|
MelMin =  100;
MelMax = 1500;

AudioSampleRate = 48000;

LengthSum = 2.4;
TimeSum = 3;

CoefLen2Time = TimeSum/LengthSum;

NumPointSum = TimeSum*AudioSampleRate;

GapWidth = 0.01;

FreqMin = 700*exp(MelMin/1127-1);
NumPadPoint = ceil (1/FreqMin * AudioSampleRate);

CurrentPoint = 0;

%段1 |
LengthSeg = 0.8;


TimeSeg = LengthSeg * CoefLen2Time;

NumSegPoint = round(TimeSeg *AudioSampleRate);



StartX =  0.5 - LengthSeg/2 ;
StartY =  0.5 + LengthSeg/2 ;

EndX =  0.5 - LengthSeg/2 ;
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

DataAudio1 =zeros(2,ceil(TimeSeg*AudioSampleRate));


for iDot = 1:NumDot - 1
    
    DataChirp = chirp((1:SeqNumDotPoint(iDot)+NumPadPoint)/AudioSampleRate,SeqFreq(iDot),SeqNumDotPoint(iDot)/AudioSampleRate,SeqFreq(iDot+1),'logarithmic');

    if iDot == 1 %首段开头截短至0
        
        StartPoint = 1;
        while DataChirp(StartPoint)>0
            
            StartPoint = StartPoint + 1;
            
        end
        
    else
        StartPoint = 1;
        
    end

    if mod(iDot,2) == 0 %偶数段结尾截短至1
        
        EndPoint = SeqNumDotPoint(iDot);
        

        while DataChirp(EndPoint)~= max(DataChirp(EndPoint-1:EndPoint+1))
            
            EndPoint = EndPoint - 1;
        end

    elseif mod(iDot,2) == 1 %奇数段结尾延长至1
        
        EndPoint = SeqNumDotPoint(iDot);
        

        while DataChirp(EndPoint)~= max(DataChirp(EndPoint-1:EndPoint+1))
            
            EndPoint = EndPoint + 1;
        end
   
    end
    
    
    AmpRight = linspace(SeqRightAmp(iDot),SeqRightAmp(iDot+1),EndPoint-StartPoint+1);
    AmpLeft = 1 - AmpRight;
    
    DataAudio1(1,CurrentPoint+1:CurrentPoint+EndPoint-StartPoint+1) = DataChirp(StartPoint:EndPoint).*AmpLeft;
    DataAudio1(2,CurrentPoint+1:CurrentPoint+EndPoint-StartPoint+1) = DataChirp(StartPoint:EndPoint).*AmpRight;
    
    CurrentPoint = CurrentPoint+EndPoint-StartPoint+1;

end



%增删Seg数据
NumPointError = NumSegPoint - CurrentPoint;

iPoint = 2:CurrentPoint-1;

PassZeroIndex = [true,DataAudio1(1,iPoint).*DataAudio1(1,iPoint+1)<=0,false];

PassZeroIndex = find(PassZeroIndex);

iPoint = 3:CurrentPoint-1;

PeakIndex = [false,false,DataAudio1(1,iPoint-1)>= DataAudio1(1,iPoint) & DataAudio1(1,iPoint-1)>= DataAudio1(1,iPoint-2),true];

PeakIndex = find(PeakIndex);

 
  
  
  if NumPointError <0
      
      [~,StartPointIndex] = min(abs(PassZeroIndex-abs(NumPointError/2)));
      [~,EndPointIndex] = min(abs(CurrentPoint-PeakIndex-abs(NumPointError/2)));
      
      StartPoint = PassZeroIndex(StartPointIndex);
      
      EndPoint = PeakIndex(EndPointIndex);
      
      CurrentPoint = EndPoint-StartPoint+1;
      
      DataAudio1 = DataAudio1(:,StartPoint:EndPoint);
      
  elseif NumPointError >0
      
      NumStartPadHalfCycle = round(NumPointError/2/PassZeroIndex(2));
      
      iHalfCycle = 1: NumStartPadHalfCycle;
      
      SignCycle = (-1).^(NumStartPadHalfCycle -iHalfCycle+1);
      
      SignPoint = reshape(repmat(SignCycle,PassZeroIndex(2),1),1,[]);
      
      DataStartPad = repmat(DataAudio1(:,1:PassZeroIndex(2)),1,NumStartPadHalfCycle).*repmat(SignPoint,2,1);
      
      NumEndPadCycle = round(NumPointError/2/(CurrentPoint-PeakIndex(end-1)+1));
      
      DataEndPad = repmat(DataAudio1(:,PeakIndex(end-1):CurrentPoint),1,NumEndPadCycle);

      DataAudio1 = [DataStartPad,DataAudio1(:,1:CurrentPoint),DataEndPad];
      CurrentPoint = CurrentPoint+size(DataStartPad,2)+size(DataEndPad,2);
         
      
  end
%段2 _
LengthSeg = 0.8;

TimeSeg = TimeSum/3;

NumSegPoint = round(TimeSum/3 * AudioSampleRate);


StartX =  0.5 - LengthSeg/2 ;
StartY =  0.5 - LengthSeg/2 ;

EndX =  0.5 + LengthSeg/2 ;
EndY =  0.5 - LengthSeg/2 ;


MelAll = MelMin+StartY*(MelMax - MelMin);

FreqAll = 700*exp(MelAll/1127-1);


t = (1:NumSegPoint+NumPadPoint)/AudioSampleRate;

TempData = cos(2*pi*FreqAll*t);

iPoint = 2:NumSegPoint+NumPadPoint-1;

PeakIndex = [true,TempData(iPoint)>= TempData(iPoint-1) & TempData(iPoint)>= TempData(iPoint+1)];

PeakIndex = find(PeakIndex);

[~,EndPointIndex] = min(abs(PeakIndex-NumSegPoint));
EndPoint = PeakIndex(EndPointIndex);

SeqRightAmp = linspace(StartX,EndX,EndPoint);

SeqLeftAmp = 1 - SeqRightAmp;


TempData = TempData(1:EndPoint);

DataAudio2 = [TempData(1:EndPoint).*SeqLeftAmp;TempData(1:EndPoint).*SeqRightAmp];


%段3  |
LengthSeg = 0.8;

TimeSeg = TimeSum/3;

StartX = 0.5 + LengthSeg/2;
StartY = 0.5 + LengthSeg/2;

EndX = 0.5 + LengthSeg/2;
EndY = 0.5 - LengthSeg/2;

RightAmp =  StartX;
LeftAmp = 1 - RightAmp;




DataAudio3(1,:) = DataAudio1(1,end:-1:1)/(1-0.5 - LengthSeg/2)*LeftAmp;
DataAudio3(2,:) = DataAudio1(2,end:-1:1)/(0.5 - LengthSeg/2)*RightAmp;


DataAudio = [DataAudio1,DataAudio2,DataAudio3];






