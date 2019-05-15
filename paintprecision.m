which='\FaceOcc1.txt';%选择测试集
a='KCF';
b='CSK';
c='OLB';
d='C.T';
e='Sem';
f='MIL';
g='SMI';
h='TLD';
Datasets=[a;b;c;d;e;f;g;h];
where=['F:\matlabworkplace\SMILEGUI\Image\',which(1,2:length(which)-4),'\groundtruth_rect.txt'];%原x,y,w,h目录
[x,y,w,h]=textread([where],'%n %n %n %n','delimiter',',');
threshold=int32(min(w(1,1),h(1,1))/2);%从w和h中取比较短的一边除以2作为精度阈值
P=[];
disp('各算法精度和平均距离');
num=500;%前多少帧
for i=2:7
    path=['F:\matlabworkplace\SMILEGUI\OTB\',Datasets(i,1:3),which];%跟踪结果Dist目录
    distance=textread(path);
    precision=zeros(100,1);
    for j=1:100%计算精度矩阵的循环
        for k=1:num
            if(distance(k,1)<=j)
                precision(j,1)=precision(j,1)+1;
            end
        end
        precision(j,1)=precision(j,1)/num;%计算精度
    end
    disp([Datasets(i,1:3),':',num2str(precision(threshold,1)),'      ',num2str(mean(distance(1:num,1)))]);%打印精度
    P=[P,precision];%所有算法的精度矩阵
end
plot(P(:,1),'cyan','LineWidth',2);
hold on;
plot(P(:,2),'magenta','LineWidth',2);
hold on;
plot(P(:,3),'green','LineWidth',2);
hold on;
plot(P(:,4),'blue','LineWidth',2);
hold on;
plot(P(:,5),'yellow','LineWidth',2);
hold on;
plot(P(:,6),'red','LineWidth',2);
% set(gca,'fontname','Times New Roman','fontsize',32);%设置坐标的字体
% xlabel('\fontname{方正书宋简体}阈值','FontSize',26), ylabel('\fontname{方正书宋简体}精度','FontSize',26);
% set(gcf,'PaperUnits','centimeters','PaperPosition',[0,0,16.115,16.115*3/4],'PaperPositionMode', 'manual');
which=which(1,2:length(which)-4);
% title(which,'FontName','Times New Romen','FontSize',26);
% l1=legend('CSK','OnlineBoosting','CT','SemiBoosting','MIL','SMILE','TLD');
% set(l1,'FontName','Times New Romen','FontSize',26);%设置标注的字体
% saveas(gcf,['C:\Users\fighting\Desktop\Precision\',which,'.jpg']);
% print('-djpeg','-r600',which);