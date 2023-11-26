clc;
clear;
close all;
file1 = {'..\dataset\natural_training\*.jpg','..\dataset\manmade_training\*.jpg'};
file2 = {'..\dataset\natural_test\*.jpg','..\dataset\manmade_test\*.jpg'};
Train = TrainingLoader(file1);
Test = TestLoader(file2);
length_natural = length(dir(file2{1}));
length_natural_train = length(dir(file1{1}));

traintemp = Training_characters_temp(Train);
testtemp = Test_characters_temp(Test);

% pB_LDA
% matrix = struct('r',[],'g',[],'b',[],'h',[],'s',[],'v',[],'l',[],'a',[],'b1',[],'texture',[]);
matrix = struct('h',[],'texture',[]);
% matrix(1).r = pB_LDA({traintemp.r},length_natural_train,0.8);
% matrix(1).g = pB_LDA({traintemp.g},length_natural_train,0.8);
% matrix(1).b = pB_LDA({traintemp.b},length_natural_train,0.8);
matrix(1).h = pB_LDA({traintemp.h},length_natural_train,0.8);
% matrix(1).s = pB_LDA({traintemp.s},length_natural_train,0.8);
% matrix(1).v = pB_LDA({traintemp.v},length_natural_train,0.8);
% matrix(1).l = pB_LDA({traintemp.l},length_natural_train,0.8);
% matrix(1).a = pB_LDA({traintemp.a},length_natural_train,0.8);
% matrix(1).b1 = pB_LDA({traintemp.b1},length_natural_train,0.8);
matrix(1).texture = pB_LDA({traintemp.texture},length_natural_train,0.8);
%完成纹理特征提取就去掉注释
%%
fid = fopen(('.\data\kresults.txt'),'w');

for k = 1:2:20
    [sort_result,time,ratio,ratio_natural,ratio_manmade] = partB_plus(Train,Test,length_natural_train,length_natural,traintemp,testtemp,matrix, k);
    fprintf(fid, num2str(k));
    fprintf(fid, ' ' );
    fprintf(fid, num2str(time));
    fprintf(fid, ' ' );
    fprintf(fid, num2str(ratio*100));
    fprintf(fid, ' ' );
    fprintf(fid, num2str((1-ratio_natural)*100));
    fprintf(fid, ' ' );
    fprintf(fid, num2str((1-ratio_manmade)*100));
    fprintf(fid, ' \n' );
    disp(strcat('k=',num2str(k)));
    disp(strcat('cpu time during:',num2str(time),'s'));
    disp(strcat('overall accuracy:',num2str(ratio*100),'%'));
    disp(strcat('misclassification rate of natural:',num2str((1-ratio_natural)*100),'%'));
    disp(strcat('misclassification rate of manmade:',num2str((1-ratio_manmade)*100),'%'));
    
end
fclose(fid);
