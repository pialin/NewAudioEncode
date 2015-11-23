d = 0.4 *tan(pi/6);

x1 = 0.1;
y1 = 0.5-d;
x2 = 0.5;
y2 = 0.5+2*d;
x3 = 0.9;
y3 = 0.5-d;

MelMin =  300;
MelMax = 1100;
CoefXtoT = 1.5;
SampleRateAudio = 48000;
LengthPerSeg = 0.01;
TimePerSeg = LengthPerSeg * CoefXtoT;

%%

LengthLine = sqrt((x2-x1)^2+(y2-y1)^2) ;
NumSeg = round(LengthLine/LengthPerSeg)+1;

NumPointPerSeg = TimePerSeg*SampleRateAudio;

x = linspace(x1,x2,NumSeg);

y = ((y1-y2)/(x1-x2))*(x-x2) + y2;

mel =  y*(MelMax-MelMin)+MelMin;

f = 700*exp(mel/1127-1);

DataAudio1 = zeros(1,NumPointPerSeg*(NumSeg-1));
CurrentIndex = 0;

for iSeg = 1:NumSeg - 1
    
    
    DataChirp = chirp((1:NumPointPerSeg)/SampleRateAudio,f(iSeg),NumPointPerSeg/SampleRateAudio,f(iSeg+1),'logarithmic');
    
    for iPoint = numel(DataChirp)-1:-1:2
        
        if DataChirp(iPoint)> DataChirp(iPoint-1) &&  DataChirp(iPoint)> DataChirp(iPoint+1)
            
            break;
        end
        
    end
    
    AmpRight = linspace(x(iSeg),x(iSeg+1),iPoint);
    AmpLeft =1-AmpRight;
    
    DataAudio1(1,CurrentIndex+1:CurrentIndex+iPoint) = DataChirp(1:iPoint).*AmpLeft;
    DataAudio1(2,CurrentIndex+1:CurrentIndex+iPoint) = DataChirp(1:iPoint).*AmpRight;
    
    CurrentIndex =CurrentIndex+iPoint;
    

end
DataAudio1 = DataAudio1(:,1:CurrentIndex);

sound(DataAudio1,SampleRateAudio);



%%
LengthLine = sqrt((x3-x2)^2+(y3-y2)^2) ;
NumSeg = round(LengthLine/LengthPerSeg)+1;

x = linspace(x2,x3,NumSeg);

y = ((y2-y3)/(x2-x3))*(x-x3) + y3;

mel =  y*(MelMax-MelMin)+MelMin;

f = 700*exp(mel/1127-1);

DataAudio2 = zeros(1,NumPointPerSeg*(NumSeg-1));
CurrentIndex = 0;

for iSeg = 1:NumSeg - 1
    
    DataChirp = chirp((1:NumPointPerSeg)/SampleRateAudio,f(iSeg),NumPointPerSeg/SampleRateAudio,f(iSeg+1),'logarithmic');
    
    for iPoint = numel(DataChirp)-1:-1:2
        
        if DataChirp(iPoint)> DataChirp(iPoint-1) &&  DataChirp(iPoint)> DataChirp(iPoint+1)
            
            break;
        end
        
    end
    
    AmpRight = linspace(x(iSeg),x(iSeg+1),iPoint);
    AmpLeft =1-AmpRight;
    
    DataAudio2(1,CurrentIndex+1:CurrentIndex+iPoint) = DataChirp(1:iPoint).*AmpLeft;
    DataAudio2(2,CurrentIndex+1:CurrentIndex+iPoint) = DataChirp(1:iPoint).*AmpRight;
    
    CurrentIndex =CurrentIndex+iPoint;
    
    
end
DataAudio2 = DataAudio2(:,1:CurrentIndex);

sound(DataAudio2,SampleRateAudio);

%%
LengthLine = sqrt((x1-x3)^2+(y1-y3)^2) ;
NumSeg = round(LengthLine/LengthPerSeg)+1;

x = linspace(x3,x1,NumSeg);

y = ((y3-y1)/(x3-x1))*(x-x1) + y1;

mel =  y*(MelMax-MelMin)+MelMin;

f = 700*exp(mel/1127-1);

DataAudio3 = zeros(1,NumPointPerSeg*(NumSeg-1));
CurrentIndex = 0;

for iSeg = 1:NumSeg - 1
    if abs(f(iSeg)-f(iSeg+1))<1
        
        DataChirp = chirp((1:NumPointPerSeg)/SampleRateAudio,f(iSeg),NumPointPerSeg/SampleRateAudio,f(iSeg+1),'linear');
        
    else
        
        DataChirp = chirp((1:NumPointPerSeg)/SampleRateAudio,f(iSeg),NumPointPerSeg/SampleRateAudio,f(iSeg+1),'logarithmic');
        
    end
    
    for iPoint = numel(DataChirp)-1:-1:2
        
        if DataChirp(iPoint)> DataChirp(iPoint-1) &&  DataChirp(iPoint)> DataChirp(iPoint+1)
            
            break;
        end
        
    end
    
    AmpRight = linspace(x(iSeg),x(iSeg+1),iPoint);
    AmpLeft =1-AmpRight;
    
    DataAudio3(1,CurrentIndex+1:CurrentIndex+iPoint) = DataChirp(1:iPoint).*AmpLeft;
    DataAudio3(2,CurrentIndex+1:CurrentIndex+iPoint) = DataChirp(1:iPoint).*AmpRight;
    
    CurrentIndex =CurrentIndex+iPoint;
    
    
end
DataAudio3 = DataAudio3(:,1:CurrentIndex);

sound(DataAudio3,SampleRateAudio);


DataAudio = [DataAudio1,DataAudio2,DataAudio3];
sound(DataAudio,SampleRateAudio);







