function kog = cal_chip(c_img,c_img_g)
kog = (c_img - c_img_g)./sqrt(c_img + c_img_g + eps);
kog = kog'*kog*0.5;