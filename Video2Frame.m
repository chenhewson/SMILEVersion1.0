function  Video2Frame(Videopath,filepath)
if isempty(Videopath)==1||isempty(filepath)==1
    msgbox('无效路径！.', 'NOTING');
else
    a=msgbox('正在将视频转换图片帧请稍等...', 'NOTING');
    obj=VideoReader(Videopath);%读取视频，这里生产一个关于视频的结构体

    numframe=obj.NumberOfFrames;%视频的总帧数
    for k=1:numframe
        frame=read(obj,k);
        imwrite(frame,[filepath,'\',strcat(num2str(k,'%04d'),'.jpg')],'jpg');
            %保存图片
    end
    try
        close(a);
    catch
    end
    b=msgbox('图片帧转换完成', 'NOTING');
    try
        close(b);
    catch
    end
    
    
    
    
end
end