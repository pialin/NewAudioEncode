%ExpTrain��������

%����ʹ�õ�����ɫ

red = [white,black,black];
green = [black,white,black];
blue = [black,black,white];
gray = white/2;


TimeSum = 3;
NumSeg = 3;
NumSumPoint = round(TimeSum*FramePerSecond);
TimeSeg =[1,1,1];
NumSegPoint = round(TimeSeg*FramePerSecond);
SegStartPoint = round((cumsum(TimeSeg)-1)*FramePerSecond)+1;
SeqPointX =  zeros(1,NumSumPoint);
SeqPointY =  zeros(1,NumSumPoint);

SizeCanvas = round(SizeScreenY*3/5);


LineWidth = 20;



iSet = 1;
%��1 
t = linspace(0,TimeSeg(iSeg),NumSegPoint(iSeg));
SeqPointX(SegStartPoint(iSeg):SegEndPoint(iSeg)+NumSegPoint(iSeg)-1)= 0.1;
SeqPointY(SegStartPoint(iSeg):SegEndPoint(iSeg)+NumSegPoint(iSeg)-1)= linspace(0.9,0.1,NumSegPoint(iSeg));

iSet = iSet+1;
%��2
SeqPointX(SegStartPoint(iSeg):SegEndPoint(iSeg)+NumSegPoint(iSeg)-1)= linspace(0.9,0.1,NumSegPoint(iSeg));
SeqPointY(SegStartPoint(iSeg):SegEndPoint(iSeg)+NumSegPoint(iSeg)-1)= 0.1;

iSet = iSet+1;
%��3
SeqPointX(SegStartPoint(iSeg):SegEndPoint(iSeg)+NumSegPoint(iSeg)-1)= 0.9;
SeqPointY(SegStartPoint(iSeg):SegEndPoint(iSeg)+NumSegPoint(iSeg)-1)= linspace(0.9,0.1,NumSegPoint(iSeg));

