function  Video2Frame(Videopath,filepath)
if isempty(Videopath)==1||isempty(filepath)==1
    msgbox('��Ч·����.', 'NOTING');
else
    a=msgbox('���ڽ���Ƶת��ͼƬ֡���Ե�...', 'NOTING');
    obj=VideoReader(Videopath);%��ȡ��Ƶ����������һ��������Ƶ�Ľṹ��

    numframe=obj.NumberOfFrames;%��Ƶ����֡��
    for k=1:numframe
        frame=read(obj,k);
        imwrite(frame,[filepath,'\',strcat(num2str(k,'%04d'),'.jpg')],'jpg');
            %����ͼƬ
    end
    try
        close(a);
    catch
    end
    b=msgbox('ͼƬ֡ת�����', 'NOTING');
    try
        close(b);
    catch
    end
    
    
    
    
end
end