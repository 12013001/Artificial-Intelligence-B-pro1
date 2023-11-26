function [solution]=selectphoto_hist(table,target,row_size)
%% 定义各类参数
[w, h, ~]=size(target);    %目标图像原尺寸
div_size = floor(w / row_size);    %每个tile的尺寸
col_size = floor(row_size * h/w);    %生成图像的列数
[rows,cols]=size(table);    %图片集table的尺寸

trg=target;
trg=imresize(trg,[row_size * div_size, col_size * div_size]);
[w, h, ~]=size(trg);
%%
r_hist=[];
g_hist=[];
b_hist=[];
parfor i=1:rows
    hist_src=table{i,'hist'};
    hist_src=hist_src{1};
    r_hist(:,:,i)=double(hist_src(:,1));
    g_hist(:,:,i)=double(hist_src(:,2));
    b_hist(:,:,i)=double(hist_src(:,3));
end

rhs=repmat(r_hist,row_size,col_size);
ghs=repmat(g_hist,row_size,col_size);
bhs=repmat(b_hist,row_size,col_size);

clear hist_src r_hist g_hist b_hist
%% 下面通过直方图距离判断图片相似度
histmat_r=[];
histmat_g=[];
histmat_b=[];
div = 32;
for i=0:(row_size - 1)
    for j=0:(col_size - 1)
        I = target(i*div_size + 1: (i+1)*div_size, j*div_size + 1: (j+1)*div_size, :);
        %I = gaussian(I);
        
        % Compute histogram of an original tile
        [r,~]=imhist(I(:, :, 1), div);
        [g,~]=imhist(I(:, :, 2), div);
        [b,~]=imhist(I(:, :, 3), div);
        histmat_r(i*div+1:(i+1)*div,j+1) = r ./ (div_size^2);
        histmat_g(i*div+1:(i+1)*div,j+1) = g ./ (div_size^2);
        histmat_b(i*div+1:(i+1)*div,j+1) = b ./ (div_size^2);
    end
end

% Compute Chi-Square Distance
histmat_r = repmat(histmat_r, 1, 1, rows);
histmat_g = repmat(histmat_g, 1, 1, rows);
histmat_b = repmat(histmat_b, 1, 1, rows);
hist_r = 0.5 * (abs(rhs-histmat_r).^2) ./ (rhs+histmat_r+0.0001);    % Plus 0.0001 to avoid zero in the denominator
hist_g = 0.5 * (abs(ghs-histmat_g).^2) ./ (ghs+histmat_g+0.0001);
hist_b = 0.5 * (abs(bhs-histmat_b).^2) ./ (bhs+histmat_b+0.0001);
hist = hist_r + hist_g + hist_b;

clear rhs ghs bhs histmat_r histmat_g histmat_b hist_r hist_g hist_b
hist_dist = zeros(row_size,col_size,rows);
for i=0:(row_size-1)
    for j=0:(col_size-1)
        hist_dist(i+1,j+1,:) = sum(hist(i*div+1: div*(i+1), j+1, :),1);
        %hist_dist(i+1,j+1,:) = normalize(sum(hist(i*div+1: div*(i+1), j+1, :),1),'norm',1);
    end
end

clear hist
for i=1:row_size
    parfor j=1:col_size
        hist_dist(i,j,:) = (hist_dist(i,j,:) - min(hist_dist(i,j,:))) ./ (max(hist_dist(i,j,:)) - min(hist_dist(i,j,:)));
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