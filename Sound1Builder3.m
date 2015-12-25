clear;
syms mel y t f;
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


LenSum = 2.4;
CoefLen2Time = TimeSum/LenSum;

NumSeg = 3;

iSeg = 1;

LenSeg = zeros(1,NumSeg);
TimeSeg = zeros(1,NumSeg);
NumSegPoint = zeros(1,NumSeg);
SegStartPoint = zeros(1,NumSeg);
SegStartPoint(1) = 1;
%¶Î1 |
LenSeg(iSeg) = LenSum/3;
TimeSeg(iSeg) =  LenSeg(iSeg)*CoefLen2Time;
NumSegPoint(iSeg) = round(TimeSeg(iSeg)*AudioSampleRate);
SegStartPoint(iSeg+1) = SegStartPoint(iSeg) +NumSegPoint(iSeg);

fi(iSeg) = subs(f,y,sym('0.9-0.8*t'));
intfi(iSeg) = int(fi(iSeg),t,0,t);

AmpR(iSeg) = sym('0.1');
ValueIntf(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
    double(subs(intfi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));
ValueAmpR(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
    double(subs(AmpR(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));


iSeg = iSeg +1;
%¶Î2 _
LenSeg(iSeg) = LenSum/3;
TimeSeg(iSeg) =  LenSeg(iSeg)*CoefLen2Time;
NumSegPoint(iSeg) = round(TimeSeg(iSeg)*AudioSampleRate);
SegStartPoint(iSeg+1) = SegStartPoint(iSeg) +NumSegPoint(iSeg);

fi(iSeg) = subs(f,y,'0.1');
intfi(iSeg) = int(fi(iSeg),t,0,t);

AmpR(iSeg) = sym('0.8*t+0.1');

ValueIntf(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
    double(subs(intfi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))))+ValueIntf(SegStartPoint(iSeg)-1);
ValueAmpR(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = ...
    double(subs(AmpR(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));


iSeg = iSeg +1 ;
%¶Î3 |

LenSeg(iSeg) = LenSum/3;
TimeSeg(iSeg) =  LenSeg(iSeg)*CoefLen2Time;
NumSegPoint(iSeg) = round(TimeSeg(iSeg)*AudioSampleRate);


fi(iSeg) = subs(f,y,'0.8*t+0.1');
intfi(iSeg) = int(fi(iSeg),t,0,t);

AmpR(iSeg) = sym('0.9');

ValueIntf(SegStartPoint(iSeg):end) = ...
    double(subs(intfi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))))+ValueIntf(SegStartPoint(iSeg)-1);
ValueAmpR(SegStartPoint(iSeg):end) = ...
    double(subs(AmpR(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg))));



ValueAmpL = 1 - ValueAmpR; 
t = linspace(0,TimeSum,NumSumPoint);

DataAudio= [ValueAmpL;ValueAmpR].*repmat(cos(2*pi*ValueIntf.*t),2,1);
