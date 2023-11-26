function [matrix] = pB_LDA(train,length_natural_train,ratio)
%传入元胞数组train与标记natural的标签结束长度，以及降维贡献度阈值ratio，ratio=0-1
%ratio并非越大越好！lda降维后，新特征向量随着相应特征值的降低而关联性越来越低，
%盲目引入过多新特征无异于引入毫无关联的噪音干扰预测，且过多新特征容易导致运算速度慢
%一般建议ratio设置为0.7-0.9之间，设置过低或直接拉满设置为1效果都会很差。
%传出投影矩阵/降维矩阵
train_m_character_nature = zeros([length_natural_train,length(train{1})]);
train_m_character_manmade = zeros([length(train)-length_natural_train,length(train{1})]);

for i = 1:length_natural_train 
   train_m_character_nature(i,:) = train{i}; 
   
end
for i = length_natural_train+1:length(train) 
   train_m_character_manmade(i-length_natural_train,:) = train{i};
   
end
matrix = pB_LDA_generate(train_m_character_nature,train_m_character_manmade,ratio);
end

