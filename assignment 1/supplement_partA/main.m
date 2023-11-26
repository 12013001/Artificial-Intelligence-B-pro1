clear
clc
path='../dataset/';
txtname='training.txt';
trg=imread('../lena_colour.jpg');
[r, c, ~] = size(trg);      % Get the size of target image
%'../images/005.jpg'
%%
pixel_num = 360000;       % Select the number of pixels
tile_num = 3600;          % Select the number of tiles

% %cheat
% div = 10;
% row_size = 40;
% tile_num = row_size.^2 * c/r;
% pixel_num = div.^2 * tile_num;

div_pixel = floor(sqrt(pixel_num / tile_num)); % Number of pixels per row of a tile
trg_row_size = floor(sqrt(tile_num * r/c));    % Number of tiles per row of output image
%%

table = photoinfo(1, path, txtname, div_pixel);
%%
%solution = selectphoto_mse(4, table, trg, trg_row_size);
%solution = selectphoto_hist(table, trg, trg_row_size);
%solution = selectphoto_hsv(table, trg, trg_row_size);
solution = selectphoto_corr(table, trg, trg_row_size);
%solution = selectphoto_final(table, trg, trg_row_size);    %hist+corr

img = Imfill(solution, path, table, trg, div_pixel);
imshow(img)