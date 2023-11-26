function [label] = knn_D(sortedhist, item, k,matrix)
%KNN 
%1.算距离：给定测试集中待分类样本item（输入转换过的图像格式与直方图），计算它与已分类样本（训练集）中每个样本（已转换格式）的距离；
%2.圈定与待分类样本最近的k个已分类样本，作为待分类样本近邻；
%3.根据这k个近邻中的大部分样本所属的类别来判定item类别；
%返回对应要检测item的类别0或1；

%新建保存k个最近邻的label和distance的struct，其中我们要保证k个元素按照distance升序排列。
nearby = struct('label',[],'distance',[]);%
nearby(1) = [];
nearby = repmat(nearby,[1,k]);
for i = 1:k
    nearby(i).label = 0;%初始化标签。
    nearby(i).distance = Inf;%初始化所有元素distance均为正无穷，方便后续从前面插入元素
end

%算出已分类训练集每张图与item的距离temp_dist，并与nearby中的元素正序依次比较。
%若在nearby中某个位置j找到distance比temp_dist大的数据，则将w及其之后的元素向后移一格（覆盖最后一个元素),并将sortedstruct第i个元素插入j位置，跳出循环。
for i = 1:length(sortedhist)
    temp_dist = pB_distance(sortedhist(i),item,matrix);
    for j = 1:length(nearby)%小插入排序。
        if (temp_dist < nearby(j).distance)
            for w = length(nearby):-1:j+1
                nearby(w).label = nearby(w-1).label;
                nearby(w).distance = nearby(w-1).distance;
            end
            nearby(j).label = sortedhist(i).label;
            nearby(j).distance = temp_dist;
            break;
        end
    end
end

%计算k个近邻元素label之和，若大于k/2,则取输出label为1.
% sum_label = 0;
% for i = 1:length(nearby)
%     sum_label = sum_label + nearby(i).label;
% end
% if sum_label >= double(k/2)%默认如果近邻元素的label数量0和1相等，则取1。
%     label = 1;
% else
%     label = 0;
% end

sum_label = 0;
for i = 1:length(nearby)
    sum_label = sum_label + nearby(i).label*(length(nearby)-i+1);
end
total = double(((1+k)*k)/2);
if sum_label >= double(total/2)%默认如果近邻元素的label数量0和1相等，则取1。
    label = 1;
else
    label = 0;
end

end

