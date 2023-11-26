target1 = imread('..\target1.jpg');

file_paths = {'..\dataset\natural_training\*.jpg','..\dataset\manmade_training\*.jpg',...
    '..\dataset\manmade_test\*.jpg','..\dataset\natural_test\*.jpg'};

repeat = 500;
target = target1;
tile = 12000;
pixel = [800,1200]; 
start_time = cputime;
mosaic = partA(target,pixel,tile,repeat,file_paths);
end_time = cputime; 
%%
figure();
imshow(mosaic);
title(strcat('cpu time during:',num2str(floor(end_time - start_time)),'s'),'fontsize',16);
%%
clear;
