function photable = photoinfo(sepnumber,path,txtname,div_size)
namelist={};
sizelist={};
colormatrixlist={};
histlist={};
hsvlist={};
correlist={};
div = 32;

txt=[path,txtname];
fpn = fopen(txt,'rt');              %打开文档  
while feof(fpn) ~= 1                %用于判断文件指针p在其所指的文件中的位置，如果到文件末，函数返回1，否则返回0  
    file = fgetl(fpn);              %获取文档第一行                      
    new_str=file;                   %中间这部分是对读取的字符串file进行任意处理  
    namelist=[namelist new_str];
end

for name=namelist
    I=imread([path,name{1}]);
    [x, y, z]=size(I);
    edg=min(x,y);
    sizelist=[sizelist edg];
    I=I(1:edg,1:edg,:);
    I = gaussian(I);
    I=imresize(I,[div_size,div_size]);
    histmat=[];
    for k=1:3
        hist=imhist(I(1: div_size, 1: div_size, k), div);
        hist = hist ./ (div_size.^2);
        histmat(:, k)=hist;
    end
    
    HSV = rgb2hsv(I);
    hsvmat=[];
    for k=1:3
        hist=imhist(HSV(1: div_size, 1: div_size, k), div);
        hist = hist ./ (div_size.^2);
        hsvmat(:, k)=hist;
    end
    
    corremat = correlogram(I, round(div_size/3)); % Call the color correlogram function, d= 1/3 of image width
    I=imresize(I,[sepnumber,sepnumber]);
    colormatrixlist=[colormatrixlist I];
    histlist=[histlist histmat];
    hsvlist=[hsvlist hsvmat];
    correlist=[correlist corremat];
end

photable=table(namelist', colormatrixlist', sizelist', histlist', hsvlist', correlist','VariableNames',{'name','color','size','hist','hsv','corr'});
end