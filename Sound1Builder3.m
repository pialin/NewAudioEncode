clear;
syms mel y t f;
fi = sym('f',[3,1]);
infi = sym('f',[3,1]);

f =sym('700*exp(mel/1127-1)');

f = subs(f,mel,sym('100+y*1400'));

AudioSampleRate = 48000;

TimeSum = 3;

valuef = zeros(1,round(TimeSum*AudioSampleRate));


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

valuef(SegStartPoint(iSeg):SegStartPoint(iSeg+1)-1) = subs(intfi(iSeg),t,linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg)));

iSeg = iSeg +1;
%¶Î2 _

%¶Î3 |