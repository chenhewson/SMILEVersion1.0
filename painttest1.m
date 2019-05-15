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
Dist=[];
num=500;%帧数
for i=2:7
    path=['F:\matlabworkplace\SMILEGUI\OTB\',Datasets(i,1:3),which];%跟踪结果Dist目录
    distance=textread(path);
    distance=distance(1:num,:);
    Dist=[Dist,distance];
end
% set(gcf,'PaperUnits','centimeters','PaperPosition',[0,0,16.115,16.115*3/4],'PaperPositionMode', 'manual');
for i=1:length(Dist)
    plot(Dist(1:i,1),'cyan','LineWidth',2);
    hold on;
    plot(Dist(1:i,2),'magenta','LineWidth',2);
    hold on;
    plot(Dist(1:i,3),'green','LineWidth',2);
    hold on;
    plot(Dist(1:i,4),'blue','LineWidth',2);
    hold on;
    plot(Dist(1:i,5),'yellow','LineWidth',2);
    hold on;
    plot(Dist(1:i,6),'red','LineWidth',2);
    axis([0 length(Dist) 0 200]);%坐标轴的范围
    m(i)=getframe;%将当前图形存入矩阵m中
end
% set(gca,'fontname','Times New Roman','fontsize',32);%设置坐标的字体
% xlabel('\fontname{方正书宋简体}帧序','FontSize',26),ylabel('\fontname{方正书宋简体}中心位置误差\fontname{Times New Roman}(\fontname{方正书宋简体}像素\fontname{Times New Roman})','FontSize',26);
which=which(1,2:length(which)-4);
% title(which,'FontName','Times New Romen','FontSize',26);
% l1=legend('CSK','OLB','CT','SMB','MIL','SMILE','TLD');
% set(l1,'FontName','Times New Romen','FontSize',26,'location','Best');%设置标注的字体
% saveas(gcf,['C:\Users\fighting\Desktop\Dist\',which,'.jpg']);%保存图片
% print('-f1','-djpeg','-r600',which);