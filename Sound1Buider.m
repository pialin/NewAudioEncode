%Sound of |_|
MelMin =  100;
MelMax = 1500;

AudioSampleRate = 48000;

LengthSum = 2.4;
TimeSum = 3;
CoefLen2Time = TimeSum/LengthSum;
NumPointSum = TimeSum*AudioSampleRate;
DataAudio = zeros(2,NumPointSum);

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
    
    DataAudio(1,CurrentPoint+1:CurrentPoint+EndPoint-StartPoint+1) = DataChirp(StartPoint:EndPoint).*AmpLeft;
    DataAudio(2,CurrentPoint+1:CurrentPoint+EndPoint-StartPoint+1) = DataChirp(StartPoint:EndPoint).*AmpRight;
    
    CurrentPoint = CurrentPoint+EndPoint-StartPoint+1;

end

%增删Seg数据
  NumPointError = NumSegPoint - CurrentPoint;
  
  iPoint = 1:CurrentPoint-1;
  
  
  PassZeroIndex = [DataAudio(1,iPoint).*DataAudio(1,iPoint+1)<=0,false];
      
  iPoint = 2:CurrentPoint-1;
  
  PeakIndex = [false,DataChirp(iPoint)>= DataAudio(1,iPoint-1) && DataChirp(iPoint)>= DataAudio(1,iPoint+1) ,true];
  
  
  for iPoint = 1:CurrentPoint
  
      PassZeroIndex = DataAudio(1,iPoint) 
      
      PeakIndex = 
  
  end
  
  iPoint = 1 ;
 
  
  while DataAudio(1,iPoint)< 0
      
      iPoint = iPoint + 1; 
      
  end
  
  %前面修正的单位点数
  StartCorrect =  iPoint;
  
  iPoint = CurrentPoint - 1 ;
  
  while DataAudio(1,iPoint) ~= max(DataAudio(1,iPoint-1:iPoint+1))
      
      iPoint = iPoint - 1; 
      
  end

  %后面修正的点数
  EndCorrect = CurrentPoint - iPoint ;
  
  DataAudio(5*StartCorrect:CurrentPoint)
  

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


SeqRightAmp = linspace(StartX,EndX,NumSegPoint);

SeqLeftAmp = 1 - SeqRightAmp;


t = linspace(0,TimeSeg,NumSegPoint);

DataAudio(1,CurrentPoint+1:CurrentPoint+NumSegPoint) = cos(2*pi*FreqAll*t).*SeqLeftAmp;
DataAudio(2,CurrentPoint+1:CurrentPoint+NumSegPoint) = cos(2*pi*FreqAll*t).*SeqRightAmp;

 CurrentPoint = CurrentPoint+NumSegPoint;
% 
% DataAudio = DataAudio(:,1:CurrentPoint);
