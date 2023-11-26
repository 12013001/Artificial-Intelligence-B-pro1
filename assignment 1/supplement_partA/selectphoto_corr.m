function [solution]=selectphoto_corr(table,target,row_size)
%% 定义各类参数
[w, h, ~]=size(target);    %目标图像原尺寸
div_size = floor(w / row_size);    %每个tile的尺寸
col_size = floor(row_size * h/w);    %生成图像的列数
[rows,cols]=size(table);    %图片集table的尺寸

trg=target;
trg=imresize(trg,[row_size * div_size, col_size * div_size]);
[w, h, ~]=size(trg);
%%
corr=[];
parfor i=1:rows
    corr_src=table{i,'corr'};
    corr_src=corr_src{1};
    corr(:,:,i)=double(corr_src);
end
corrs = repmat(corr,row_size,col_size);
clear corr_src corr
%% 下面通过颜色相关图距离判断图片相似度
corrmat=[];
corr = [];
div = 64;
for i=0:(row_size - 1)
    for j=0:(col_size - 1)
        I = target(i*div_size + 1: (i+1)*div_size, j*div_size + 1: (j+1)*div_size, :);
%         I = gaussian(I);
        corrmat(i*div+1:(i+1)*div,j+1) = correlogram(I, round(div_size/3));
    end
end

corrmat = repmat(corrmat, 1, 1, rows);
%corr = abs(corrs-corrmat) .^2;
corr = 0.5 * (abs(corrs-corrmat).^2) ./ (corrs+corrmat+0.001);    % 加0.001避免分母为零

clear corrs corrmat
corr_dist = zeros(row_size,col_size,rows);
for i=0:(row_size-1)
    for j=0:(col_size-1)
        corr_dist(i+1,j+1,:) = sum(corr(i*div+1: div*(i+1), j+1, :),1);
    end
end

clear corr
for i=1:row_size
    parfor j=1:col_size
        corr_dist(i,j,:) = (corr_dist(i,j,:) - min(corr_dist(i,j,:))) ./ (max(corr_dist(i,j,:)) - min(corr_dist(i,j,:)));
    end
end

solution=zeros(row_size,col_size);
for i=1:row_size
    parfor j=1:col_size
        [~, index]=min(corr_dist(i,j,:));
        solution(i,j)=index;
    end
end
end