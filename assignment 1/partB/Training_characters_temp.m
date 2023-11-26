function [hist] = Training_characters_temp(Trainingstruct)
%TRAINING_HIST 此处显示有关此函数的摘要
%   此处显示详细说明
% hist = struct('r',[],'g',[],'b',[],'h',[],'s',[],'v',[],'l',[],'a',[],'b1',[],'texture',[]);
hist = struct('h',[],'texture',[]);
hist(1) = [];
hist = repmat(hist,[1,length(Trainingstruct)]);
for i = 1:length(Trainingstruct)
%     [r,g,b] = imsplit(Trainingstruct(i).data);
    [h,s,v] = imsplit(rgb2hsv(Trainingstruct(i).data));
%     [l,a,b1] = imsplit(rgb2lab(Trainingstruct(i).data));
%     hist(i).r = imhist(r)/(size(r,1)*size(r,2)); 
%     hist(i).g = imhist(g)/(size(g,1)*size(g,2)); 
%     hist(i).b = imhist(b)/(size(b,1)*size(b,2));
    
    hist(i).h = imhist(h)/(size(h,1)*size(h,2));
%     hist(i).s = imhist(s)/(size(s,1)*size(s,2));
%     hist(i).v = imhist(v)/(size(v,1)*size(v,2));
    
%     hist(i).l = imhist(l)/(size(l,1)*size(l,2));
%     hist(i).a = imhist(a)/(size(a,1)*size(a,2));
%     hist(i).b1 = imhist(b1)/(size(b1,1)*size(b1,2));
    %
%     temp = zeros([100,100,3]);
%     temp(:,:,1) = imresize(Trainingstruct(i).data(:,:,1),[100,100]);
%     temp(:,:,2) = imresize(Trainingstruct(i).data(:,:,2),[100,100]);
%     temp(:,:,3) = imresize(Trainingstruct(i).data(:,:,3),[100,100]);
%     feature = double(extractHOGFeatures(uint8(temp)))';
%     hist(i).texture = feature/sum(feature(:));
    
    % 此处等待拓展装载texture和structure的操作
    temp = rgb2gray(Trainingstruct(i).data);
    GLCM = graycomatrix(temp,'Offset',[1 0;0 1;-1 -1;1 1]);
    stats = graycoprops(GLCM,{'contrast','homogeneity','correlation','energy'});
    homo = {stats.Homogeneity};
    con = {stats.Contrast};
    cor = {stats.Correlation};
    en = {stats.Energy};
    t = [homo{:},con{:},cor{:},en{:}]';
    hist(i).texture = t/(sum(t(:)));
    
    %
end

end

