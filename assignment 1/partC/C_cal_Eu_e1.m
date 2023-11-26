function k = C_cal_Eu_e1(h1,h2)
%CAL_EU_E1 此处显示有关此函数的摘要
%   此处显示详细说明
h = 1+abs(h1 - h2);
k = (h'*h)/length(h);
k = exp(k) - exp(1);
end

