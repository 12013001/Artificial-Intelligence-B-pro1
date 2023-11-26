function [solution]=selectphoto_final(table,target,row_size)
%% 定义各类参数
[w, h, ~]=size(target);    %目标图像原尺寸
div_size = floor(w / row_size);    % Size of each tile
col_size = floor(row_size * h/w);    % Tile number per column
[rows,cols]=size(table);    %图片集table的尺寸

trg=target;
trg=imresize(trg,[row_size * div_size, col_size * div_size]);
[w, h, ~]=size(trg);
%% 计算直方图分数
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
histmat_r=[];
histmat_g=[];
histmat_b=[];
div = 32;
for i=0:(row_size - 1)
    for j=0:(col_size - 1)
        I = target(i*div_size + 1: (i+1)*div_size, j*div_size + 1: (j+1)*div_size, :);
        %I = gaussian(I);
        [r,~]=imhist(I(:, :, 1), div);
        [g,~]=imhist(I(:, :, 2), div);
        [b,~]=imhist(I(:, :, 3), div);
        %histmat_r(i*div+1:(i+1)*div,j+1) = normalize(r,'norm',1);
        %histmat_g(i*div+1:(i+1)*div,j+1) = normalize(g,'norm',1);
        %histmat_b(i*div+1:(i+1)*div,j+1) = normalize(b,'norm',1);
        histmat_r(i*div+1:(i+1)*div,j+1) = r ./ (div_size^2);
        histmat_g(i*div+1:(i+1)*div,j+1) = g ./ (div_size^2);
        histmat_b(i*div+1:(i+1)*div,j+1) = b ./ (div_size^2);
    end
end

histmat_r = repmat(histmat_r, 1, 1, rows);
histmat_g = repmat(histmat_g, 1, 1, rows);
histmat_b = repmat(histmat_b, 1, 1, rows);
hist_r = 0.5 * (abs(rhs-histmat_r).^2) ./ (rhs+histmat_r+0.0001);    % 加0.0001避免分母为零
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
save hist_dist hist_dist
%% 计算颜色相关图分数
corr=[];
parfor i=1:rows
    corr_src=table{i,'corr'};
    corr_src=corr_src{1};
    corr(:,:,i)=double(corr_src);
end
corrs = repmat(corr,row_size,col_size);

clear corr_src corr
corrmat=[];
corr = [];
div = 64;
for i=0:(row_size - 1)
    for j=0:(col_size - 1)
        I = target(i*div_size + 1: (i+1)*div_size, j*div_size + 1: (j+1)*div_size, :);
        %I = gaussian(I);
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
save corr_dist corr_dist
%% 加权计算结果
dist = 0.5 * hist_dist + 0.5 * corr_dist;    % 调整权重

solution=zeros(row_size,col_size);
for i=1:row_size
    parfor j=1:col_size
        [~, index]=min(dist(i,j,:));
        solution(i,j)=index;
    end
end
end