target_path = 'target1.jpg';
%file_manmade = {'..\dataset\manmade_training\*.jpg','..\dataset\manmade_test\*.jpg'};
%file_natural = {'..\dataset\natural_training\*.jpg','..\dataset\natural_test\*.jpg'};
tile = 12000;
pixel = [800,1200];

[mosaic,class] = partC(target_path,tile,pixel);
%%
clear;