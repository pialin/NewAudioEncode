%ExpTrain��ExpFormal��������

%%
%��ʾ��������
%����ʹ�õ�����ɫ

red = [white,black,black];
green = [black,white,black];
blue = [black,black,white];
gray = white/2;

%����ʹ�С����
FontName = '΢���ź�';
FontSize = 40;

%ͼ����ʾ����Ĵ�С
SizeCanvas = round(SizeScreenY*3/5);

%ͼ����ʾԭ�������
OriginX = round((SizeScreenX - SizeCanvas)/2);
OriginY = SizeCanvas + round((SizeScreenY - SizeCanvas)/2);


%ͼ���������
PenWidth = 20;

%%
%��Ƶ��������

%��Ƶ������
AudioSampleRate = 48000;
%��������
AudioVolume = 0.8;
%����������
PowerWhiteNoise = 2;

%��ʾ��Ƶ��
FreqHintSound = 800;


%%
%ʵ���������
%���ж��ٸ�Trial
NumTrial = 2;
%��ͼ������
NumPattern =24;


%���������ظ�����
ReplayTimes = 2;





%�Ѷ�����
DifficultySetting = 1:3;
PatternDifficulty(1,:) =  1: 8;
PatternDifficulty(2,:) =  9:16;
PatternDifficulty(3,:) = 17:24;

%%

%ʱ���������

TimeHintSound  = 6;

TimeWhiteNoise = 2;

TimeGapSilence = 2;

TimeSum = 3; 


%�����������
LptAddress = 53264;

%���ڱ�Ǻ���˵��
%1-200:��ʾÿ��trial�Ŀ�ʼ
%201-249:����
%250:��ʾ��ʼ���Ÿ�˹������
%251:��ʾʵ�鿪ʼ����ʾ����ʼ���ţ�
%252:����
%253:ʵ����ΪESC�������¶���ֹ
%254:��ʾʵ����������



