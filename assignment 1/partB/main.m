%% partB.
clc;
close all;
clear;
file1 = {'..\dataset\natural_training\*.jpg','..\dataset\manmade_training\*.jpg'};
file2 = {'..\dataset\natural_test\*.jpg','..\dataset\manmade_test\*.jpg'};
k = 39; 

[sort_result,time,ratio,ratio_natural,ratio_manmade] = partB(file1, file2, k);
disp(strcat('cpu time during:',num2str(time),'s'));
disp(strcat('overall accuracy:',num2str(ratio*100),'%'));
disp(strcat('misclassification rate of natural:',num2str((1-ratio_natural)*100),'%'));
disp(strcat('misclassification rate of manmade:',num2str((1-ratio_manmade)*100),'%'));