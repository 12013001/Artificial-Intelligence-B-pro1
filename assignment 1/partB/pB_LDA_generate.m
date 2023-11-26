function matrix_p = pB_LDA_generate(trainhist_m_nature,trainhist_m_manmade,ratio)
%传入训练集的样本矩阵，以及阈值ratio，ratio=0-1.
%传出LDA的投影矩阵
mean_nature = mean(trainhist_m_nature);
mean_manmade = mean(trainhist_m_manmade);
temp = trainhist_m_nature-mean_nature;
var_nature = (temp'*temp)./size(trainhist_m_nature,1);
temp = trainhist_m_manmade-mean_manmade;
var_manmade = (temp'*temp)./size(trainhist_m_manmade,1);

sw = var_nature + var_manmade;
temp = mean_nature - mean_manmade;
sb = temp'*temp;

A = pinv(sw)*sb;
[w,lam] = eig(A);
lam = abs(sum(lam));
cumulate = 0;
q = length(lam);
for i = 1:length(lam)
    cumulate = lam(i) + cumulate;
    if cumulate >= ratio*sum(lam)
        q = i;
        break;
    end
end
matrix_p = zeros([size(w,1),q]);
for i = 1:q
   matrix_p(:,i) = w(:,i); 
end

end