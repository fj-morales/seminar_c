h = 3;
w = 3;
my = sym('a',[1 h*w]);
mym = reshape(my,h,w);

grad_m = gradient(h,w);
comprob = grad_m * mym(:)