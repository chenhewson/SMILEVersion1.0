function [P] = getPrecision( groundpath,trackingpath,which1)%函数返回值为精度矩阵
% which='\Deer.txt';%选择测试集
which=['\',which1,'.txt'];%选择测试集
a='KCF';
b='CSK';
c='OLB';
d='C.T';
e='Sem';
f='MIL';
g='SMI';
h='TLD';
Datasets=[a;b;c;d;e;f;g;h];
% where=['E:\目标跟踪\tracker_release2\data\Benchmark\',which(1,2:length(which)-4),'\groundtruth_rect.txt'];%原x,y,w,h目录
where=[groundpath,which(1,2:length(which)-4),'\groundtruth_rect.txt'];%原x,y,w,h目录
[x,y,w,h]=textread([where],'%n %n %n %n','delimiter',',');
threshold=int32(min(w(1,1),h(1,1))/2);%从w和h中取比较短的一边除以2作为精度阈值
P=[];
for i=2:7
%     path=['E:\目标跟踪\OTB\',Datasets(i,1:3),which];%跟踪结果Dist目录
    path=[trackingpath,Datasets(i,1:3),which];%跟踪结果Dist目录
    distance=textread(path);
    precision=zeros(100,1);
    for j=1:100%计算精度矩阵的循环
        for k=1:length(distance)
            if(distance(k,1)<=j)
                precision(j,1)=precision(j,1)+1;
            end
        end
        precision(j,1)=precision(j,1)/length(distance);%计算精度
    end
    P=[P,precision];%所有算法的精度矩阵
end
end

