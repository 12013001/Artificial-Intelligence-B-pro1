function [ratio, ratio0, ratio1] = correctratio(struct,type1)
%CORRECTRATIO 此处显示有关此函数的摘要
%将sort后的测试集导入到此，type1为测试集自然图像数，（总数-type1）为测试集人工图像数。

correctnum0 = 0;
for i = 1:type1
    if struct(i).label == 0
        correctnum0 = correctnum0 + 1;
    end
end
ratio0 = double(correctnum0/type1);

correctnum1 = 0;
for j = type1+1:length(struct)
    if struct(j).label == 1
        correctnum1 = correctnum1 + 1;
    end
end
ratio1 = double(correctnum1/(length(struct)-type1));

ratio = double((correctnum0+correctnum1)/length(struct));
end

