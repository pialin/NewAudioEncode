%ExpTrain和ExpFormal参数设置

%%
%显示参数设置
%定义使用到的颜色

red = [white,black,black];
green = [black,white,black];
blue = [black,black,white];
gray = white/2;

%字体和大小设置
FontName = '微软雅黑';
FontSize = 40;

%图案显示区域的大小
SizeCanvas = round(SizeScreenY*3/5);

%图案显示原点的坐标
OriginX = round((SizeScreenX - SizeCanvas)/2);
OriginY = SizeCanvas + round((SizeScreenY - SizeCanvas)/2);


%图案宽度设置
PenWidth = 20;

%%
%音频参数设置

%音频采样率
AudioSampleRate = 48000;
%音量设置
AudioVolume = 0.8;
%白噪声功率
PowerWhiteNoise = 2;

%提示音频率
FreqHintSound = 800;


%%
%实验参数设置
%进行多少个Trial
NumTrial = 2;
%总图案个数
NumPattern =24;


%编码声音重复次数
ReplayTimes = 2;





%难度设置
DifficultySetting = 1:3;
PatternDifficulty(1,:) =  1: 8;
PatternDifficulty(2,:) =  9:16;
PatternDifficulty(3,:) = 17:24;

%%

%时间参数设置

TimeHintSound  = 6;

TimeWhiteNoise = 2;

TimeGapSilence = 2;

TimeSum = 3; 


%并口相关设置
LptAddress = 53264;

%并口标记含义说明
%1-200:表示每个trial的开始
%201-249:保留
%250:表示开始播放高斯白噪声
%251:表示实验开始（提示音开始播放）
%252:保留
%253:实验因为ESC键被按下而中止
%254:表示实验正常结束



