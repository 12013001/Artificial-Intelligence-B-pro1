function image = Imfill(solution,path,table,trg,div_size)

finalpicture={};
[x,y,~] = size(solution);
for i=1:x
    parfor j=1:y
        ind=solution(i,j);
        pic=table{ind,:};
        I=imread([path pic{1}]);
        I=I(1:pic{3},1:pic{3},:);
        I = gaussian(I);
        I=imresize(I,[div_size,div_size]);
        finalpicture(i,j)={I};
    end
end


image=cell2mat(finalpicture);
imshow(trg)
figure