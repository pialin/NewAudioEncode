r = 0.4;

x1 = 0.1;
y1 = 0;

x2 = 0.9;
y2 = 0;



MelMin =  300;
MelMax = 1100;
CoefXtoT = 1.5;
SampleRateAudio = 48000;
LengthPerSeg = 0.01;
TimePerSeg = LengthPerSeg * CoefXtoT;
NumPointPerSeg = TimePerSeg*SampleRateAudio;
%%

LengthLine = 2*pi*0.4/2;
NumSeg = round(LengthLine/LengthPerSeg)+1;


x = linspace(x1,x2,NumSeg);

y = sqrt(r^2-(x-0.5).^2) + 0.5;

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
LengthLine = 2*pi*0.4/2;
NumSeg = round(LengthLine/LengthPerSeg)+1;


x = linspace(x2,x1,NumSeg);

y = 0.5 - sqrt(r^2-(x-0.5).^2);

mel =  y*(MelMax-MelMin)+MelMin;

f = 700*exp(mel/1127-1);

DataAudio2 = zeros(1,NumPointPerSeg*(NumSeg-1));
CurrentIndex = 0;

for iSeg = 1:NumSeg - 1
    
    
    DataChirp = chirp((1:NumPointPerSeg)/SampleRateAudio,f(iSeg),NumPointPerSeg/SampleRateAudio,f(iSeg+1),'logarithmic');
    
    if iSeg == NumSeg -1
        
        for iPoint = numel(DataChirp):-1:1
            
            if DataChirp(iPoint)*DataChirp(iPoint-1) <= 0
                
                break;
            end
            
        end
        
        
    else
        for iPoint = numel(DataChirp)-1:-1:2
            
            if DataChirp(iPoint)> DataChirp(iPoint-1) &&  DataChirp(iPoint)> DataChirp(iPoint+1)
                
                break;
            end
            
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


DataAudio = [DataAudio1,DataAudio2 ];
sound(DataAudio,SampleRateAudio);
