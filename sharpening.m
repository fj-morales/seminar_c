function out_image = sharpening (input_img_filename, output_img_filename)
image=imread(input_img_filename);
[h w d]=size(image);
Ubar = double(reshape(image,w*h,d))/255;

%% Write your method here
cs = 3;
cu = 0.5;
G = gradient(h,w);
g = (G * Ubar);
I = speye(size(G,2)); % Sparse identity matrix
U =(G'*G +cu*I)\(cs*G'*g + cu*Ubar);

%%
out_image =uint8(reshape(U,h,w,d)*255);

imwrite(image,output_img_filename);