clc;
clear;
close all;


images_name = importdata('.\competition\images.txt');

for i = 1:length(images_name)
    x = images_name{i,1};
    image = imread(strcat('.\competition\Images\',x));
    hist = struct('h',[],'texture',[]);
    hist(1) = [];
    [h,a5,a6] = imsplit(rgb2hsv(image));
    hist(1).h = imhist(h)/(size(h,1)*size(h,2));
    temp = rgb2gray(image);
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
    output_label = knn_D(model_data(1).traintemp,hist(1),39,model_data(1).matrix);
    pB_test_end = cputime;
    sign = strcat('B',num2str(i+1));
    if (output_label == 0)
        
        xlswrite('.\competition\images.csv',{'1'},'images',sign);
        disp('natural');
    else
        xlswrite('.\competition\images.csv',{'0'},'images',sign);
        disp('Man-made');
    end
end

