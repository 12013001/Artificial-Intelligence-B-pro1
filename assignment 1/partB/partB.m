function [Test,test_time,correct_rate_all,correct_rate_natural,correct_rate_manmade]= partB(file1,file2,k)
% file1 = {} 输入已知类别的训练集
% file2 = {} 输入未分类的测试集
% k 设定knn中邻近元素的个数

%%
% 准备数据阶段
Train = TrainingLoader(file1);
Test = TestLoader(file2);
length_natural = length(dir(file2{1}));
length_natural_train = length(dir(file1{1}));
disp('read all...');

%%
% 此处为先转换出需要的图像格式与直方图，这样会破坏封装性，但是会节省大量时间。
traintemp = Training_characters_temp(Train);
testtemp = Test_characters_temp(Test);
disp('temp all...');

%% pB_LDA
matrix = struct('h',[],'texture',[]);
matrix(1).h = pB_LDA({traintemp.h},length_natural_train,0.8);
matrix(1).texture = pB_LDA({traintemp.texture},length_natural_train,0.9);
%完成纹理特征提取就去掉注释
disp('matrix all...');
%%
%执行knn,将测试集中label（原先全为0）替换为sort结果
start_timeB = cputime;
for i = 1:length(testtemp)
    if rem(i,length(Test)/10) == 0
        disp(strcat('processing:',num2str((i/length(Test))*100),'%'));
    end
    output_label = knn(Train, traintemp, testtemp(i),k,matrix);
    Test(i).label = output_label;
end
end_timeB = cputime;
test_time = floor(end_timeB - start_timeB);
%%
%测试分类效果
[correct_rate_all,correct_rate_natural,correct_rate_manmade]= correctratio(Test,length_natural);
end