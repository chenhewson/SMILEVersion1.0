which='\FaceOcc1.txt';%ѡ����Լ�
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
num=500;%֡��
for i=2:7
    path=['F:\matlabworkplace\SMILEGUI\OTB\',Datasets(i,1:3),which];%���ٽ��DistĿ¼
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
    axis([0 length(Dist) 0 200]);%������ķ�Χ
    m(i)=getframe;%����ǰͼ�δ������m��
end
% set(gca,'fontname','Times New Roman','fontsize',32);%�������������
% xlabel('\fontname{�������μ���}֡��','FontSize',26),ylabel('\fontname{�������μ���}����λ�����\fontname{Times New Roman}(\fontname{�������μ���}����\fontname{Times New Roman})','FontSize',26);
which=which(1,2:length(which)-4);
% title(which,'FontName','Times New Romen','FontSize',26);
% l1=legend('CSK','OLB','CT','SMB','MIL','SMILE','TLD');
% set(l1,'FontName','Times New Romen','FontSize',26,'location','Best');%���ñ�ע������
% saveas(gcf,['C:\Users\fighting\Desktop\Dist\',which,'.jpg']);%����ͼƬ
% print('-f1','-djpeg','-r600',which);