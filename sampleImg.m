function samples = sampleImg(img,initstate,inrad,outrad,maxnum)
% $Description:
%    -Compute the coordinate of sample image templates计算样本图像模板的坐标
% $Agruments
% Input;
%    -img: inpute image
%    -initistate: [x y width height] object position 
%    -inrad: outside radius of region
%    -outrad: inside radius of region
%    -maxnum: maximal number of samples
%-IMG:IpPUT图像
%-初始化状态：[x y宽度高度]对象位置
%-Irad：区域外半径
%-ourad：区域内半径
%-Max NUM:最大样本数
% Output:
%    -samples.sx: x coordinate vector,[x1 x2 ...xn]
%    -samples.sy: y ...
%    -samples.sw: width ...
%    -samples.sh: height...
% $ History $
%   - Created by Kaihua Zhang, on April 22th, 2011
%   - Revised by Kaihua Zhang, on May 25th, 2011
%  rand('state',0);%important

inrad = ceil(inrad);
outrad= ceil(outrad); %返回大于或者等于指定表达式的最小整数

[row,col] = size(img);
x = initstate(1);
y = initstate(2);
w = initstate(3);
h = initstate(4);

rowsz = row - h - 1;
colsz = col - w - 1;

inradsq  = inrad^2;
outradsq = outrad^2;

minrow = max(1, y - inrad+1);
maxrow = min(rowsz-1, y+inrad);
mincol = max(1, x-inrad+1);
maxcol = min(colsz-1, x+inrad);

prob = maxnum/((maxrow-minrow+1)*(maxcol-mincol+1));
i = 1;
%--------------------------------------------------
%--------------------------------------------------
[r,c] = meshgrid(minrow:maxrow,mincol:maxcol);
dist  = (y-r).^2+(x-c).^2;
rd = rand(size(r));

ind = (rd<prob)&(dist<inradsq)&(dist>=outradsq);
c = c(ind==1);
r = r(ind==1);

samples.sx = c';
samples.sy = r';
samples.sw = w*ones(1,length(r(:)));
samples.sh = h*ones(1,length(r(:)));
%--------------------------------------------------
% for r = minrow:maxrow
%     for c = mincol:maxcol
%         dist = (y-r)^2 + (x-c)^2;         
%         if (rand<prob)&(dist<inradsq)&(dist>=outradsq)
%             samples.sx(i) = c;
%             samples.sy(i) = r;
%             samples.sw(i) = w;
%             samples.sh(i) = h;
%             i=i+1;
%         end
%     end    
% end
