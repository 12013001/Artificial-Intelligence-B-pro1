function I = C_gaussian(img)
    h = fspecial('gaussian',[3 3],2);
    I = imfilter(img,h,'conv');
end