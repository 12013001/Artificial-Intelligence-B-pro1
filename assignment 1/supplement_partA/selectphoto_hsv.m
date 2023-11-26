function [solution]=selectphoto_hsv(table,target,row_size)
%% 定义各类参数
[w, h, ~]=size(target);    %目标图像原尺寸
div_size = floor(w / row_size);    %每个tile的尺寸
col_size = floor(row_size * h/w);    %生成图像的列数
[rows,cols]=size(table);    %图片集table的尺寸

trg=target;
trg=imresize(trg,[row_size * div_size, col_size * div_size]);
[w, h, ~]=size(trg);
%%
h_hist=[];
s_hist=[];
v_hist=[];
parfor i=1:rows
    hist_src=table{i,'hsv'};
    hist_src=hist_src{1};
    h_hist(:,:,i)=double(hist_src(:,1));
    s_hist(:,:,i)=double(hist_src(:,2));
    v_hist(:,:,i)=double(hist_src(:,3));
end

hhs=repmat(h_hist,row_size,col_size);
shs=repmat(s_hist,row_size,col_size);
vhs=repmat(v_hist,row_size,col_size);
clear hist_src h_hist s_hist v_hist
%% 下面通过直方图距离判断图片相似度
histmat_h=[];
histmat_s=[];
histmat_v=[];
div = 32;
for i=0:(row_size - 1)
    for j=0:(col_size - 1)
        I = target(i*div_size + 1: (i+1)*div_size, j*div_size + 1: (j+1)*div_size, :);
        I = rgb2hsv(I);    % From RGB to HSV
        [h,~]=imhist(I(:, :, 1), div);
        [s,~]=imhist(I(:, :, 2), div);
        [v,~]=imhist(I(:, :, 3), div);
        histmat_h(i*div+1:(i+1)*div,j+1) = h ./ (div_size^2);
        histmat_s(i*div+1:(i+1)*div,j+1) = s ./ (div_size^2);
        histmat_v(i*div+1:(i+1)*div,j+1) = v ./ (div_size^2);
    end
end

histmat_h = repmat(histmat_h, 1, 1, rows);
histmat_s = repmat(histmat_s, 1, 1, rows);
histmat_v = repmat(histmat_v, 1, 1, rows);
hist_h = 0.5 * (abs(hhs-histmat_h).^2) ./ (hhs+histmat_h+0.0001);    % Plus 0.0001 to avoid zero in the denominator
hist_s = 0.5 * (abs(shs-histmat_s).^2) ./ (shs+histmat_s+0.0001);
hist_v = 0.5 * (abs(vhs-histmat_v).^2) ./ (vhs+histmat_v+0.0001);
hist = hist_h + hist_s + hist_v;

clear hhs shs vhs histmat_h histmat_s histmat_v hist_h hist_s hist_v
hist_dist = zeros(row_size,col_size,rows);
for i=0:(row_size-1)
    for j=0:(col_size-1)
        hist_dist(i+1,j+1,:) = sum(hist(i*div+1: div*(i+1), j+1, :),1) ./ div;
        %hist_dist(i+1,j+1,:) = normalize(sum(hist(i*div+1: div*(i+1), j+1, :),1),'norm',1);
    end
end

solution=zeros(row_size,col_size);
for i=1:row_size
    parfor j=1:col_size
        [~, index]=min(hist_dist(i,j,:));
        solution(i,j)=index;
    end
end
end