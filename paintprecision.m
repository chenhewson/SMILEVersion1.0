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
where=['F:\matlabworkplace\SMILEGUI\Image\',which(1,2:length(which)-4),'\groundtruth_rect.txt'];%ԭx,y,w,hĿ¼
[x,y,w,h]=textread([where],'%n %n %n %n','delimiter',',');
threshold=int32(min(w(1,1),h(1,1))/2);%��w��h��ȡ�Ƚ϶̵�һ�߳���2��Ϊ������ֵ
P=[];
disp('���㷨���Ⱥ�ƽ������');
num=500;%ǰ����֡
for i=2:7
    path=['F:\matlabworkplace\SMILEGUI\OTB\',Datasets(i,1:3),which];%���ٽ��DistĿ¼
    distance=textread(path);
    precision=zeros(100,1);
    for j=1:100%���㾫�Ⱦ����ѭ��
        for k=1:num
            if(distance(k,1)<=j)
                precision(j,1)=precision(j,1)+1;
            end
        end
        precision(j,1)=precision(j,1)/num;%���㾫��
    end
    disp([Datasets(i,1:3),':',num2str(precision(threshold,1)),'      ',num2str(mean(distance(1:num,1)))]);%��ӡ����
    P=[P,precision];%�����㷨�ľ��Ⱦ���
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
% set(gca,'fontname','Times New Roman','fontsize',32);%�������������
% xlabel('\fontname{�������μ���}��ֵ','FontSize',26), ylabel('\fontname{�������μ���}����','FontSize',26);
% set(gcf,'PaperUnits','centimeters','PaperPosition',[0,0,16.115,16.115*3/4],'PaperPositionMode', 'manual');
which=which(1,2:length(which)-4);
% title(which,'FontName','Times New Romen','FontSize',26);
% l1=legend('CSK','OnlineBoosting','CT','SemiBoosting','MIL','SMILE','TLD');
% set(l1,'FontName','Times New Romen','FontSize',26);%���ñ�ע������
% saveas(gcf,['C:\Users\fighting\Desktop\Precision\',which,'.jpg']);
% print('-djpeg','-r600',which);