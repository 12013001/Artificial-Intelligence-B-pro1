function count = pA_distance(img1,img2)
% 计算img1与img2的相似度，默认img1与img2为struct
% 所有直方图都以概率图形式计算，因此不需要考虑两张图的大小是否要一致。

%% 如果增加了传入通道，此处需要一并修改
a11 = img1(1).c1;
a22 = img1(1).c2;
a33 = img1(1).c3;
a44 = img1(1).c4;

b11 = img2(1).c1;
b22 = img2(1).c2;
b33 = img2(1).c3;
b44 = img2(1).c4;

%% 替换处（可变）
count = (cal_Eu_e1(a11,b11) + cal_Eu_e1(a22,b22) + cal_Eu_e1(a33,b33) + cal_Eu_e1(a44,b44));
end

