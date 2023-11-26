function k = cal_Eu_e1(h1,h2)
%此为极化的欧几里得距离
h = 1+abs(h1 - h2);
k = (h'*h)/length(h);
k = exp(k) - exp(1);
end

