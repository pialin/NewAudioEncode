%Sound of |_|
MelMin =  100;
MelMax = 1500;

AudioSampleRate = 48000;

LengthSum = 2.4;
TimeSum = 3;
NumPointSum = TimeSum*AudioSampleRate;
DataAudio = zeros(2,NumPointSum);

GapWidth = 0.01;

FreqMin = 700*exp(MelMin/1127-1);
NumPadPoint = ceil (1/FreqMin * AudioSampleRate);

CurrentPoint = 0;

%段1 |
LengthSeg = 0.8;

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

SeqNumDotPoint = round(abs(SeqY(1:end-1)- SeqY(2:end))*AudioSampleRate);

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
        
        while ~(DataChirp(EndPoint)> DataChirp(EndPoint-1) &&  DataChirp(EndPoint)> DataChirp(EndPoint+1))
            
            EndPoint = EndPoint - 1;
        end

    elseif mod(iDot,2) == 1 %奇数段结尾延长至1
        
        EndPoint = SeqNumDotPoint(iDot);
        
        while ~(DataChirp(EndPoint)> DataChirp(EndPoint-1) &&  DataChirp(EndPoint)> DataChirp(EndPoint+1))
            
            EndPoint = EndPoint + 1;
        end
   
    end
    
    
    AmpRight = linspace(SeqRightAmp(iDot),SeqRightAmp(iDot+1),EndPoint-StartPoint+1);
    AmpLeft = 1 - AmpRight;
    
    DataAudio(1,CurrentPoint+1:CurrentPoint+EndPoint-StartPoint+1) = DataChirp(StartPoint:EndPoint).*AmpLeft;
    DataAudio(2,CurrentPoint+1:CurrentPoint+EndPoint-StartPoint+1) = DataChirp(StartPoint:EndPoint).*AmpRight;
    
    CurrentPoint = CurrentPoint+EndPoint-StartPoint+1;

end


%段2 _

LengthSeg = 0.8;


StartX =  0.5 - LengthSeg/2 ;
StartY =  0.5 - LengthSeg/2 ;

EndX =  0.5 + LengthSeg/2 ;
EndY =  0.5 - LengthSeg/2 ;

FreqAll = StartY


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

SeqNumDotPoint = round(abs(SeqY(1:end-1)- SeqY(2:end))*AudioSampleRate);

SeqMel = MelMin+SeqY*(MelMax - MelMin);

SeqFreq = 700*exp(SeqMel/1127-1);

SeqRightAmp = SeqX;
SeqLeftAmp = 1-SeqX;





DataAudio = DataAudio(:,1:CurrentPoint);
