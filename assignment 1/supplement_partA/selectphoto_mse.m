function [solution]=selectphoto_mse(sepnumber,table,target,row_size)
%% 定义各类参数
[w, h, ~]=size(target);    %目标图像原尺寸
div_size = floor(w / row_size);    %每个tile的尺寸
col_size = floor(row_size * h/w);    %生成图像的列数
[rows,cols]=size(table);    %图片集table的尺寸

trg=target;
trg=imresize(trg,[row_size * div_size, col_size * div_size]);
[w, h, ~]=size(trg);
%% 
rmat=zeros(sepnumber,sepnumber,rows);
gmat=zeros(sepnumber,sepnumber,rows);
bmat=zeros(sepnumber,sepnumber,rows);
for i=1:rows
    form=table{i,'color'};
    form=double(form{1});
    rmat(:,:,i)=double(form(:,:,1));
    gmat(:,:,i)=double(form(:,:,2));
    bmat(:,:,i)=double(form(:,:,3));
end
rs=repmat(rmat,row_size,col_size);
gs=repmat(rmat,row_size,col_size);
bs=repmat(rmat,row_size,col_size);
trg=imresize(trg,[row_size*sepnumber,col_size*sepnumber]);%将图片缩小到需要的大小
trg=double(trg);
%% 接下来是通过均方误差判断图片颜色是否匹配
rc=abs(rs-trg(:,:,1));
gc=abs(gs-trg(:,:,2));
bc=abs(bs-trg(:,:,3));
square = rc.^2 + gc.^2 + bc.^2;
mse=zeros(row_size,col_size,rows);
for i=0:(row_size-1)
    for j=0:(col_size-1)
        mse(i+1,j+1,:) = sum(sum(square(i*sepnumber+1:sepnumber*(i+1),j*sepnumber+1:sepnumber*(j+1),:),1)./(sepnumber)^2, 2);
    end
end

solution=zeros(row_size,col_size);
%寻找每块方差最小的图片
for i=1:row_size
    for j=1:col_size
        [~, index]=min(mse(i,j,:));
        solution(i,j) = index;
    end
end
end