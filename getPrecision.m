function [P] = getPrecision( groundpath,trackingpath,which1)%��������ֵΪ���Ⱦ���
% which='\Deer.txt';%ѡ����Լ�
which=['\',which1,'.txt'];%ѡ����Լ�
a='KCF';
b='CSK';
c='OLB';
d='C.T';
e='Sem';
f='MIL';
g='SMI';
h='TLD';
Datasets=[a;b;c;d;e;f;g;h];
% where=['E:\Ŀ�����\tracker_release2\data\Benchmark\',which(1,2:length(which)-4),'\groundtruth_rect.txt'];%ԭx,y,w,hĿ¼
where=[groundpath,which(1,2:length(which)-4),'\groundtruth_rect.txt'];%ԭx,y,w,hĿ¼
[x,y,w,h]=textread([where],'%n %n %n %n','delimiter',',');
threshold=int32(min(w(1,1),h(1,1))/2);%��w��h��ȡ�Ƚ϶̵�һ�߳���2��Ϊ������ֵ
P=[];
for i=2:7
%     path=['E:\Ŀ�����\OTB\',Datasets(i,1:3),which];%���ٽ��DistĿ¼
    path=[trackingpath,Datasets(i,1:3),which];%���ٽ��DistĿ¼
    distance=textread(path);
    precision=zeros(100,1);
    for j=1:100%���㾫�Ⱦ����ѭ��
        for k=1:length(distance)
            if(distance(k,1)<=j)
                precision(j,1)=precision(j,1)+1;
            end
        end
        precision(j,1)=precision(j,1)/length(distance);%���㾫��
    end
    P=[P,precision];%�����㷨�ľ��Ⱦ���
end
end

