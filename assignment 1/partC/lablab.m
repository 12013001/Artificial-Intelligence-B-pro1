man = C_dataLoader([100,100],{'..\dataset\manmade_training\*.jpg','..\dataset\manmade_test\*.jpg'});
na = C_dataLoader([100,100],{'..\dataset\natural_training\*.jpg','..\dataset\natural_test\*.jpg'});
%%
man = na;

na_loader_hist = struct('c1',[],'c2',[],'c3',[],'c4',[]);
na_loader_hist(1) = [];
na_loader_hist = repmat(na_loader_hist,[1,length(man)]);
for i = 1:length(man)
    [a4,a5,a6] = imsplit(rgb2hsv(man(i).data));
    [a1,a2,a3] = imsplit(man(i).data);
    na_loader_hist(i).c1 = imhist(a1)/(size(a1,1)*size(a1,2));
    na_loader_hist(i).c2 = imhist(a2)/(size(a2,1)*size(a2,2));
    na_loader_hist(i).c3 = imhist(a3)/(size(a3,1)*size(a3,2));
    na_loader_hist(i).c4 = imhist(a4)/(size(a4,1)*size(a4,2));
end
%%