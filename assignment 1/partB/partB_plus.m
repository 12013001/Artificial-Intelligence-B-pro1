function [Test,test_time,correct_rate_all,correct_rate_natural,correct_rate_manmade]= partB_plus(Train,Test,length_natural_train,length_natural,traintemp,testtemp,matrix,k)
% traintemp 输入已知类别的训练集的mat文件
% testtemp 输入未分类的测试集的mat文件
% k 设定knn中邻近元素的个数

%%
%执行knn,将测试集中label（原先全为0）替换为sort结果
start_timeB = cputime;
for i = 1:length(testtemp)
    output_label = knn(Train, traintemp, testtemp(i),k,matrix);
    Test(i).label = output_label;
end
end_timeB = cputime;
test_time = floor(end_timeB - start_timeB);
%%
%测试分类效果
[correct_rate_all,correct_rate_natural,correct_rate_manmade]= correctratio(Test,length_natural);
end