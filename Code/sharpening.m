function out_image = sharpening (input_img_filename, output_img_filename,cs,cu)
%Sharpening
%   This function sharpens the imput image using Gradient-based Image
%   Sharpening
%   Input: filenames of input (i.e. blurry) and output (i.e. sharpened)images 
%   as well as parameters cs and cu. cs controls the scaling of the gradients cu penalizes the 
%   deviation from the input image.
%   Output: output image, which is also saved in output_img_filename

%processing initial image
image=imread(input_img_filename);
[h w d]=size(image);
Ubar = double(reshape(image,w*h,d))/255;

%% Write your method here
%Gradient based image sharpening
G = gradient(image);
g = (G * Ubar);
I = speye(size(G,2)); % Sparse identity matrix
U =(G'*G +cu*I)\(cs*G'*g + cu*Ubar); %finding sharpened image

%%reshaping output image and saving it into a file
out_image =uint8(reshape(U,h,w,d)*255);
imwrite(out_image,output_img_filename);