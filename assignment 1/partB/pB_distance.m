function count = pB_distance(img1,img2,matrix)
% 计算img1与img2的相似度，默认img1与img2为struct，传入的matrix也为struct
% 所有特征图都以概率图形式计算，因此不需要考虑两张图的大小是否要一致。

%% 如果增加了传入通道，此处需要一并修改
% ar = img1(1).r;
% br = img2(1).r;
% mr = matrix(1).r;

% ag = img1(1).g;
% bg = img2(1).g;
% mg = matrix(1).g;

% ab = img1(1).b;
% bb = img2(1).b;
% mb = matrix(1).b;

ah = img1(1).h;
bh = img2(1).h;
mh = matrix(1).h;

% as = img1(1).s;
% bs = img2(1).s;
% ms = matrix(1).s;

% av = img1(1).v;
% bv = img2(1).v;
% mv = matrix(1).v;

% al = img1(1).l;
% bl = img2(1).l;
% ml = matrix(1).l;

% aa = img1(1).a;
% ba = img2(1).a;
% ma = matrix(1).a;

% ab1 = img1(1).b1;
% bb1 = img2(1).b1;
% mb1 = matrix(1).b1;

atext = img1(1).texture;
btext = img2(1).texture;
t = matrix(1).texture;

%% 替换处（可变）
% count = cal_chip(ar'*mr,br'*mr) + cal_chip(ag'*mg,bg'*mg) + cal_chip(ab'*mb,bb'*mb) + ...
% cal_chip(ah'*mh,bh'*mh) + cal_chip(as'*ms,bs'*ms) + cal_chip(av'*mv,bv'*mv) + ...
% cal_chip(al'*ml,bl'*ml) + cal_chip(aa'*ma,ba'*ma) + cal_chip(ab1'*mb1,bb1'*mb1) + cal_chip(atext'*t,btext'*t);

count = cal_chip(ah'*mh,bh'*mh) + cal_chip(atext'*t,btext'*t);
%count = cal_chip(astruct'*s,bstruct'*s);
%count = cal_chip(ah'*m,bh'*m) + cal_chip(atext'*t,btext'*t);
%完成纹理特征提取就去掉上面的注释
end

