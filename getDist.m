function [Dist] = getDist(groudpath,which,length)
which1=['\',which,'.txt'];%ѡ����Լ�
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

for i=2:7
    path=[groudpath,Datasets(i,1:3),which1];%���ٽ��DistĿ¼
    distance=textread(path);
    distance=distance(1:length,:);
    Dist=[Dist,distance];
end
end

