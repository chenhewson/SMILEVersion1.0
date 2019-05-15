function RunTracker(flag)
%%
% Demo for paper--Kaihua Zhang, Huihui song, 'Real-time Visual Tracking via
% Online Weighted Multiple Instance Learning', Pattern Recongtion.
% Author: Kaihua Zhang, Dept. of Computing, HK PolyU.
% Email: zhkhua@gmail.com
% Date: 8/8/1011
%%
% clc;clear all;close all;
rand('state',0);% 恢复到最初产生随机数的状态
%----------------------------------
% The video sequences can be download from Boris's homepage
% http://vision.ucsd.edu/~bbabenko/project_miltrack.shtml
%----------------------------------
%----------------------------------
% Videopath = uigetdir('*.*','请选择文件夹');

%-----------------------------------------------根据数据集格式选取路径
if flag==1%flag=1为视频数据集，2为图片数据集
[file,Videopath] = uigetfile({'*.avi';'*.mp4'},'File Selector');
filepath=[Videopath,'\Frame'];
mkdir(filepath);
Video2Frame([Videopath,'\',file],filepath);
end
if flag==2%flag=1为视频数据集，2为图片数据集
filepath = uigetdir('*.*','请选择文件夹');
end
addpath(filepath);
%----------------------------------

%initial tracker
%----------------------------Set path
img_dir = dir([filepath,'\*.jpg']);
FirstFrame = imread(img_dir(1).name);
ax1=axes();
imshow(uint8(FirstFrame));
mouse=imrect;
pos=getPosition(mouse);% x1 y1 w h
ROI=[pos(1),pos(2),pos(3),pos(4)]; 
rectangle('Position',ROI,'LineWidth',2,'EdgeColor','r');
ROI=[double(uint8(pos(1))),double(uint8(pos(2))),double(uint8(pos(3))),double(uint8(pos(4)))]; 

initstate = ROI;
%-----------------------------The object position in the first frame
% x = initstate(1);% x axis at the Top left corner
% y = initstate(2);% y axis at the Top left corner
% w = initstate(3);% width of the rectangle
% h = initstate(4);% height of the rectangle
num = length(img_dir);% number of frames
%% Parameter Settings
trparams.init_negnumtrain = 50;%number of trained negative samples
trparams.init_postrainrad = 4.0;%radical scope of positive samples; boy 8
trparams.initstate = initstate;% object position [x y width height]
trparams.srchwinsz = 25;% size of search window; boy 35
%-------------------------
% classifier parameters
clfparams.width = trparams.initstate(3);
clfparams.height= trparams.initstate(4);
%-------------------------
% feature parameters:number of rectangle
ftrparams.minNumRect = 2;
ftrparams.maxNumRect = 4;
%-------------------------
lRate = 0.85;% learning rate parameter ; 0.7 for biker1
%-------------------------
M = 150;% number of all weak classifiers in feature pool
numSel = 15; % number of selected weak classifier 
isin=0;
rsconf=0.0;
csconf=0.0;
%-------------------------Initialize the feature mean and variance
posx.mu = zeros(M,1);% mean of positive features
negx.mu = zeros(M,1);
posx.sig= ones(M,1);% variance of positive features
negx.sig= ones(M,1);
%-------------------------
%compute feature template
[ftr.px,ftr.py,ftr.pw,ftr.ph,ftr.pwt] = HaarFtr(clfparams,ftrparams,M);
%% initilize the first frame
%---------------------------
img = imread(img_dir(1).name);
img = double(img(:,:,1));  %图像的第一通道
[rowz,colz] = size(img);
%---------------------------
%compute sample templates 计算样例模板
posx.sampleImage = sampleImg(img,initstate,trparams.init_postrainrad,0,100000);
negx.sampleImage = sampleImg(img,initstate,2*trparams.srchwinsz,1.5*trparams.init_postrainrad,trparams.init_negnumtrain);
%--------extract haar features 哈尔特征提取
iH = integral(img);%Compute integral image 
selector = 1:M;  % select all weak classifier in pool 选择池中所有弱分类器
posx.prob=nn(img);
posx.feature = getFtrVal(iH,posx.sampleImage,ftr,selector);
negx.feature = getFtrVal(iH,negx.sampleImage,ftr,selector);
%--------Update the weak classifiers 弱分类器的更新
[posx.mu,posx.sig,negx.mu,negx.sig] = weakClfUpdate(posx,negx,posx.mu,posx.sig,negx.mu,negx.sig,lRate);% update distribution parameters 更新分布参数
posx.pospred = weakClassifier(posx,negx,posx,selector);% Weak classifiers designed by positive samples
negx.negpred = weakClassifier(posx,negx,negx,selector);% ... by negative samples
%----------------------------------------------weight of the positive instance   
posx.w = exp(-((posx.sampleImage.sx-initstate(1)).^2+(posx.sampleImage.sy-initstate(2)).^2));
%-----------------------------------Feature selection
selector = clfWMilBoostUpdate(posx,negx,numSel);
%--------------------------------------------------------
%% Start tracking

for i = 2:num
    img1 = imread(img_dir(i).name);
    img = double(img1(:,:,1));% Only utilize one channel of image
    detectx.sampleImage = sampleImg(img,initstate,trparams.srchwinsz,0,100000);
    iH = integral(img);%Compute integral image
    detectx.feature = getFtrVal(iH,detectx.sampleImage,ftr,selector);
    %----------------------------------
    r = weakClassifier(posx,negx,detectx,selector);% compute the classifier for all samples
    prob = sum(r);% linearly combine the weak classifier in r to the strong classifier prob
    %-------------------------------------
    [c,index] = max(prob);
    %-------------------------------------
    x = detectx.sampleImage.sx(index);
    y = detectx.sampleImage.sy(index);
    w = detectx.sampleImage.sw(index);
    h = detectx.sampleImage.sh(index);
    initstate = [x y w h];
    fp=fopen([filepath,'\Result.txt'],'a');
    fprintf(fp,'%d %d %d %d\n',x,y,w,h);
    fclose(fp);
    %-----------------------------------------Show the tracking result
    imshow(uint8(img1));
    rectangle('Position',initstate,'LineWidth',4,'EdgeColor','r');
    text(5, 18, strcat('#',num2str(i)), 'Color','y', 'FontWeight','bold', 'FontSize',20);
%     set(gca,'position',[0 0 1 1]); 
    pause(0.0001); 
    %------------------------------------------    
    posx.sampleImage = sampleImg(img,initstate,trparams.init_postrainrad,0,100000);
    negx.sampleImage = sampleImg(img,initstate,1.5*trparams.srchwinsz,4+trparams.init_postrainrad,trparams.init_negnumtrain);
    %------------------------------------------------weight of the positive instance    
    posx.w = exp(-((posx.sampleImage.sx-initstate(1)).^2+(posx.sampleImage.sy-initstate(2)).^2));    
    %-----------------------------------    
    %--------------------------------------------------Update all the features in pool
    selector = 1:M;
    posx.prob=nn(img);
    if posx.prob>0.6
    M=M-1;
    selector = 1:M;
    end
    posx.feature = getFtrVal(iH,posx.sampleImage,ftr,selector);
    negx.feature = getFtrVal(iH,negx.sampleImage,ftr,selector);
    %--------------------------------------------------
    [posx.mu,posx.sig,negx.mu,negx.sig] = weakClfUpdate(posx,negx,posx.mu,posx.sig,negx.mu,negx.sig,lRate);% update distribution parameters
    posx.pospred = weakClassifier(posx,negx,posx,selector);
    negx.negpred = weakClassifier(posx,negx,negx,selector);
    %--------------------------------------------------
    selector = clfWMilBoostUpdate(posx,negx,numSel);% select the most discriminative weak classifiers 
end
msgbox(filepath,'\Result.txt');
end
%%