function I = gaussian(img)
    h = fspecial('gaussian',[5 5],2);
    I = imfilter(img,h,'conv');
end