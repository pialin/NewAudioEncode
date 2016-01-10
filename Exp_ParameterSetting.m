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
NumTrial = 24;
%总图案个数
NumPattern =24;

%难度设置
DifficultySetting = 1:3;
PatternDifficulty(1,:) =  1: 8;
PatternDifficulty(2,:) =  9:16;
PatternDifficulty(3,:) = 17:24;

%%
NumRun = 10;


if abs(fix(NumRun*NumTrial/NumPattern)-NumRun*NumTrial/NumPattern) >1e-10
    errordlg('NumRun*NumTrial应能被NumPattern整除！','参数设置错误');
    return;
end

if exist('MatrixPattern.mat','file') 
    
    load MatrixPattern.mat;
    
else
    
    %获取当前Matlab版本
    MatlabRelease = version('-release');
    
    %随机数生成器状态设置
    if str2double(MatlabRelease(1:end-1))>=2011%Matla为R2011之后版本
        rng('shuffle');
    else
        rand('twister',mod(floor(now*8640000),2^31-1));%Matlab为R2011之前版本
    end
    
    %根据难度设置计算选用的图案序号范围
    PatternRangeMin = min(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    PatternRangeMax = max(reshape(PatternDifficulty(DifficultySetting,:),1,[]),[],2);
    
    MatrixPattern = repmat(PatternRangeMin:PatternRangeMax,1,round(NumRun*NumTrial/NumPattern));
    
    MatrixPattern = reshape(Shuffle(MatrixPattern),NumRun,[]);
    
    NumUsedRow = 0;
   
    save MatrixPattern.mat MatrixPattern NumUsedRow;

end







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



