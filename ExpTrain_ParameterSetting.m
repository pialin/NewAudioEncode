%ExpTrain参数设置

%定义使用到的颜色

red = [white,black,black];
green = [black,white,black];
blue = [black,black,white];
gray = white/2;

FontName = '微软雅黑';
FontSize = 40;


TimeSum = 3;


SizeCanvas = round(SizeScreenY*3/5);

OriginX = round((SizeScreenX - SizeCanvas)/2);
OriginY = SizeCanvas + round((SizeScreenY - SizeCanvas)/2);



PenWidth = 20;

AudioSampleRate = 48000;

AudioVolume = 0.8;


NumPattern =24;

NumTrial = 2;

DifficultySetting = 1;
PatternDifficulty(1,:) =  1: 8;
PatternDifficulty(2,:) =  9:16;
PatternDifficulty(3,:) = 17:24;



TimeWhiteNoise = 2;

PowerWhiteNoise = 2;

TimeSilence1 = 2;

TimeSilence2 = 2;

TimeSilence3 = 2;

ReplayTimes = 2;

TimeCodeSound = 10; 

FreqHintSound = 1000;

TimeHintSound  = 3;

