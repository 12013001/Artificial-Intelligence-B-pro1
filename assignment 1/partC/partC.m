function [mosaic,class] = partC(target_path,tile,pixel)
k = 39;
target = imread(target_path);
hist = struct('h',[],'texture',[]);
hist(1) = [];
[h,a5,a6] = imsplit(rgb2hsv(target));
hist(1).h = imhist(h)/(size(h,1)*size(h,2));
temp = rgb2gray(target);
GLCM = graycomatrix(temp,'Offset',[1 0;0 1;-1 -1;1 1]);
stats = graycoprops(GLCM,{'contrast','homogeneity','correlation','energy'});  
homo = {stats.Homogeneity};
con = {stats.Contrast};
cor = {stats.Correlation};
en = {stats.Energy};
t = [homo{:},con{:},cor{:},en{:}]';
hist(1).texture = t/(sum(t(:)));


model_data = load('pB_model');
pB_test_start = cputime;
output_label = knn_C(model_data(1).traintemp,hist(1),k,model_data(1).matrix);
pB_test_end = cputime;
if (output_label == 0)
    disp('natural');
    class = 0;
else
    disp('Manmade');
    class = 1;
end

repeat = 1000;
start_time = cputime;
mosaic = C_partA(target,pixel,tile,repeat,class);
end_time = cputime; 

figure();
imshow(mosaic);
title(strcat('cpu time during part A:',num2str(floor(end_time - start_time)),'s. ','cpu time during part B:',num2str(floor(pB_test_end - pB_test_start)),'s. '),'fontsize',16);