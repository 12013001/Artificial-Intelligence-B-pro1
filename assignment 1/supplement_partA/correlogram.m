%% 颜色自相关图矩阵的计算
% The RGB image is quantized to the 2D image I with N * N * N colors
function output = correlogram(img, d)
    % Image quantization
    n = 2;
    bitR = n;  % Quantization number
    bitG = n;
    bitB = n;
    sizeColor = (2^bitR) * (2^bitG) * (2^bitB);  % Number of colors: 4*4*4
    imgR = img(:,:,1);
    imgG = img(:,:,2);
    imgB = img(:,:,3);
    R1 = bitshift(imgR, -(8-bitR));  % Shift
    G1 = bitshift(imgG, -(8-bitG)); 
    B1 = bitshift(imgB, -(8-bitB)); 
    I = R1 + G1*2^bitR + B1*2^bitR*2^bitB;  % 量化后的图像，包含4*4*4=64种颜色
    
    % Compute the color auto-correlogram with distance d
    temp = zeros( sizeColor, 1 );
    os = Offset(d);
    s = size(os);
    for i = 1:s(1)
        offset = os(i,:);
        glm = GLCMatrix(I, offset, sizeColor);
        temp = temp + glm;
    end
    hc = zeros( sizeColor, 1 );
    for j = 0:sizeColor-1
        hc(j+1) = numel(I(I==j));  % Count the number of pixels of each quantized value in the quantized image
    end
    output = temp./(hc+0.01);  % % Plus 0.01 to avoid zero in the denominator
    output = output/(8*d);
end

%======= 求所有距离的偏移量 =======
function os = Offset(d)
    [r,c] = meshgrid( -d:d, -d:d );
    r = r(:);  % 向量化
    c = c(:);
    os = [r c];
    bad = max( abs(r), abs(c) ) ~= d;  % 只要最大的满足d便是满足条件的
    os(bad, :) = [];
end
 
%% 灰度共生矩阵--纹理特征
function out = GLCMatrix(img, offset, n1)
% 输入：    img：输入图像
%        offset：偏移量 
%            n1：图像中包含的像素值个数
    s = size(img);
    [r, c] = meshgrid( 1:s(1), 1:s(2) );
    r = r(:);
    c = c(:);
    r2 = r + offset(1);
    c2 = c + offset(2);
 % 去掉下表超出图像边界的像素和他的邻接像素
    bad =  c2<1 | c2>s(2) | r2<1 | r2>s(1) ;
    index = [  r c r2 c2 ];
    index(bad, :) = [];
    % 分别以(r,c)和(r2,c2)为索引扎到图像img中对应的像素值向量(v1, v2)
    v1 = img( sub2ind(s, index(:,1), index(:,2)) );
    v2 = img( sub2ind(s, index(:,3), index(:,4)) );
    v1 = v1(:);
    v2 = v2(:);
    ind = [v1 v2];
    bad =  v1~=v2 ; % 去掉像素值不相同的行
    ind(bad, :) = [];
    if isempty(ind)
        oneGLCM2 = zeros(n1);
    else
        % 计算v1和v2相同的像素对数，并用n1*n1矩阵列出来
        oneGLCM2 = accumarray( ind+1, 1, [n1, n1] );
    end
    out = [];
    for i = 1:n1
        out = [ out oneGLCM2(i,i) ];
    end
    % 输出：偏移量为offset的灰度共生矩阵
    out = out(:);    
end