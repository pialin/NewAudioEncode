%Sound17
clear;
syms mel y t f kf ka;
fi = sym('f',[3,1]);
infi = sym('f',[3,1]);
AmpR = sym('AmpR',[3,1]);


f =sym('700*exp(mel/1127-1)');

f = subs(f,mel,sym('100+y*1400'));

AudioSampleRate = 48000;

TimeSum = 3;

NumSumPoint = round(TimeSum*AudioSampleRate);
ValueIntf = zeros(1,NumSumPoint);
ValueAmpR = zeros(1,NumSumPoint);


LenSum = 1.6 + 0.4*pi;
CoefLen2Time = TimeSum/LenSum;

NumSeg = 3;

iSeg = 1;

LenSeg = zeros(1,NumSeg);
TimeSeg = zeros(1,NumSeg);
NumSegPoint = zeros(1,NumSeg);
SegStartPoint = zeros(1,NumSeg);
SegStartPoint(1) = 1;
%��1 |
LenSeg(iSeg) = 0.8;
TimeSeg(iSeg) =  LenSeg(iSeg)*CoefLen2Time;
NumSegPoint(iSeg) = round(TimeSeg(iSeg)*AudioSampleRate);
SegStartPoint(iSeg+1) = SegStartPoint(iSeg) +NumSegPoint(iSeg);

fi(iSeg) = subs(f,y,sym('0.9-kf*t'));
fi(iSeg) = subs(fi(iSeg),kf,0.8/TimeSeg(iSeg));
intfi(iSeg) = int(fi(iSeg),t,0,t);

AmpR(iSeg) = sym('0.1');
AmpR(iSeg) = subs(AmpR(iSeg),ka,2/5*sqrt(5)/TimeSeg(iSeg));

ValueIntf(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
    double(subs(intfi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));
ValueAmpR(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
    double(subs(AmpR(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));


iSeg = iSeg +1;
%��2 _
LenSeg(iSeg) = 0.8;
TimeSeg(iSeg) =  LenSeg(iSeg)*CoefLen2Time;
NumSegPoint(iSeg) = round(TimeSeg(iSeg)*AudioSampleRate);
SegStartPoint(iSeg+1) = SegStartPoint(iSeg) +NumSegPoint(iSeg);

fi(iSeg) = subs(f,y,sym('0.1'));
fi(iSeg) = subs(fi(iSeg),kf,0.8/TimeSeg(iSeg));
intfi(iSeg) = int(fi(iSeg),t,0,t);

AmpR(iSeg) = sym('0.1+ka*t');
AmpR(iSeg) = subs(AmpR(iSeg),ka,0.8/TimeSeg(iSeg));

ValueIntf(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
    double(subs(intfi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))))+ValueIntf(SegStartPoint(iSeg)-1);
ValueAmpR(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
    double(subs(AmpR(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));



iSeg = iSeg +1;
%��3 )
LenSeg(iSeg) =  0.4*pi;
TimeSeg(iSeg) =  LenSeg(iSeg)*CoefLen2Time;
NumSegPoint(iSeg) = NumSumPoint-sum(NumSegPoint(1:iSeg-1));

fi(iSeg) = subs(f,y,sym('0.1+0.8*sin(kf*t)'));
fi(iSeg) = subs(fi(iSeg),kf,pi/2/TimeSeg(iSeg));

ValueF =  double(subs(fi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));
   


AmpR(iSeg) = sym('0.1+0.8*cos(ka*t)');
AmpR(iSeg) = subs(AmpR(iSeg),ka,pi/2/TimeSeg(iSeg));

T = linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg));

ValueIntf(SegStartPoint(iSeg):end) = ...
    cumtrapz(T,ValueF)+ValueIntf(SegStartPoint(iSeg)-1);
ValueAmpR(SegStartPoint(iSeg):end) = ...
    double(subs(AmpR(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));


ValueAmpL = 1 - ValueAmpR; 

DataAudio= [ValueAmpL;ValueAmpR].*repmat(cos(2*pi*ValueIntf),2,1);



%���뵭��
NumPointFadeIn = 1000;

NumPointFadeOut = 1000;

t = (-1*round(NumPointFadeIn):-1)/AudioSampleRate;

FreqFadeIn = AudioSampleRate/(2*NumPointFadeIn);

AmpFadeIn = (cos(2*pi*FreqFadeIn*t)+1)/2;

t = (1:round(NumPointFadeOut))/AudioSampleRate;

FreqFadeOut = AudioSampleRate/(2*NumPointFadeOut);

AmpFadeOut = (cos(2*pi*FreqFadeOut*t)+1)/2;


DataAudio(:,1:NumPointFadeIn)=DataAudio(:,1:NumPointFadeIn).*repmat(AmpFadeIn,2,1);


DataAudio(:,end-NumPointFadeIn+1:end)=DataAudio(:,end-NumPointFadeIn+1:end).*repmat(AmpFadeOut,2,1);


sound(DataAudio,AudioSampleRate);

save Sound17.mat DataAudio;
