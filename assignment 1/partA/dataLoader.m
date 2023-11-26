function loader = dataLoader(pre_s,file)
%使用元胞数组file来接受一系列地址文本作为输入，想输入多少个地址就输入多少个地址，返回一个装有地址目标文件的struct列表
%pre_s为预定的数据size，若输入[]则不resize。此举主要是为了加速后期匹配贴图。（几小时->几分钟）
%经过验证，调小的素材训练图的加速效果非常显著，因为imhist函数为二次方复杂度，外层又是二次方复杂度（无法避免），总共四次方复杂度，因此不建议喂太大的图进去。


loader = struct('data',[],'repeat',[]);
loader(1) = [];
path = {length(file)};

count = 0;
for j = 1:length(file) 
    path{j} = dir(file{j});
    count = count+length(path{j});
end
loader = repmat(loader,[1,count]);

step = 0;
for j = 1:length(path) 
    temp = path{j};
    for i = 1:length(temp)
        loader(step + i).data = gaussian(imread(strcat(temp(i).folder,'\',temp(i).name)));
        loader(step + i).repeat = 0;
    end
    step = step + length(temp);
end
if length(pre_s) == 2
   for i =1:length(loader)
      loader(i).data = imresize(loader(i).data,pre_s,'nearest'); 
   end
end

end

