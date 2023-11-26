function output = partA(target,pixel,tile,repeat,file)
% file = {} 输入的素材库文件地址，允许多个地址输入，请使用元胞数组
% repeat 同一张素材图允许重复使用的上限次数，不设上限就设置Inf。
% target 目标匹配图
% tile 瓷砖总数量
% pixel = [h,w]; 需要按照[h,w]格式输入。

% 准备数据阶段
select = struct('data',[]);
select(1) = [];
select = repmat(select,[1,tile]);
%以上为制作存放选中图的struct
s(1) = pixel(1);
s(2) = pixel(2);
ratio = s(2)/(s(1)+s(2)); %上下单边长度/半周长，用于计算需要的分割模式
record = 0;
count = 2;
for i = 1:tile
   if mod(tile,i) == 0
       if abs(i/(tile/i + i) - ratio) < count
          count = abs(i/(tile/i + i) - ratio);
          record = i;
       end
   end
end
width = record;
height = tile/width; % 得到最接近原图比例的分割长宽模式
delta_h = ceil(s(1)/height); % 得到分割步长
delta_w = ceil(s(2)/width);
target = imresize(target,[height*delta_h, width*delta_w],'nearest');% 把target调成容易塞入全部图的大小
s = size(target);% 更新目标size

target_sub = struct('data',[]);
target_sub(1) = [];
target_sub = repmat(target_sub,[1,tile]); %制作需要的struct
i = 0;
for w = 1:width
   for h = 1:height
       i = i+1;
       target_sub(i).data = target(1+(h-1)*delta_h:1:h*delta_h,   1+(w-1)*delta_w:1:w*delta_w,:);
   end
end % 制作target切片struct，按照从上往下，再从左往右的顺序，select需要遵从同样的顺序
% 以上为制作的target分区struct
loader_all = dataLoader([delta_h,delta_w],file);%,'.\dataset\manmade_test\*.jpg','.\dataset\natural_test\*.jpg');
% 以上为根据大小加载的数据加载器

% 在此处决定传入什么通道的直方图
% 此处为先转换出需要的图像格式与直方图，这样会破坏封装性，但是会节省大量时间。

loader_hist = struct('c1',[],'c2',[],'c3',[],'c4',[]);
loader_hist(1) = [];
loader_hist = repmat(loader_hist,[1,length(loader_all)]);
for i = 1:length(loader_all)
    [a4,a5,a6] = imsplit(rgb2hsv(loader_all(i).data));
    [a1,a2,a3] = imsplit(loader_all(i).data);
    loader_hist(i).c1 = imhist(a1)/(size(a1,1)*size(a1,2));
    loader_hist(i).c2 = imhist(a2)/(size(a2,1)*size(a2,2));
    loader_hist(i).c3 = imhist(a3)/(size(a3,1)*size(a3,2));
    loader_hist(i).c4 = imhist(a4)/(size(a4,1)*size(a4,2));
end

target_hist = struct('c1',[],'c2',[],'c3',[],'c4',[]);
target_hist(1) = [];
target_hist = repmat(target_hist,[1,length(target_sub)]);
for i = 1:length(target_sub)
    [a4,a5,a6] = imsplit(rgb2hsv(target_sub(i).data));
    [a1,a2,a3] = imsplit(target_sub(i).data);
    target_hist(i).c1 = imhist(a1)/(size(a1,1)*size(a1,2));
    target_hist(i).c2 = imhist(a2)/(size(a2,1)*size(a2,2));
    target_hist(i).c3 = imhist(a3)/(size(a3,1)*size(a3,2));
    target_hist(i).c4 = imhist(a4)/(size(a4,1)*size(a4,2));
end
disp('preparation finished');

% 接下来进入核心操作
for j = 1:tile
    if mod(j,1000) == 0 || j == tile
        %disp(strcat('processing:',num2str(j),'/',num2str(tile)));
        disp(strcat('processing:',num2str(floor((j/tile)*100)),'%'));
    end
    count = Inf;
    record = 0;  
    for i = 1:length(loader_hist)
        if loader_all(i).repeat < repeat    
            temp_dist = pA_distance(loader_hist(i),target_hist(j)); %注意select的填充顺序与target_sub一致，先上-下，再左-右
            if temp_dist <= count % 用来记录最小距离
                count = temp_dist;
                record = i;
            end
        end       
        if i == length(loader_hist) % 用来更新
            select(j).data = loader_all(record).data;
            loader_all(record).repeat = loader_all(record).repeat+1; 
        end      
    end
end

% 先选中需要的瓷砖，再去集中做处理，这样可以把最核心的距离评价函数给隔离开来
output = zeros(size(target));
i = 0;
for w = 1:width
   for h = 1:height
       i = i+1;
       output(1+(h-1)*delta_h:1:h*delta_h,1+(w-1)*delta_w:1:w*delta_w,:) = select(i).data;
   end
end
output = gaussian(output);% 高斯滤波
output_1 = medfilt2(output(:,:,1),[3,3]);
output_2 = medfilt2(output(:,:,2),[3,3]);% 中值滤波
output_3 = medfilt2(output(:,:,3),[3,3]);
output(:,:,1) = output_1;
output(:,:,2) = output_2;
output(:,:,3) = output_3;
output = uint8(imresize(output,pixel,'nearest')); % 最后再一起调整大小到希望的样子