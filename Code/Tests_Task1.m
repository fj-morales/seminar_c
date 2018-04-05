%Test for correctness - Task1
%Gradient Matrix
h = 3;
w = 3;
%Producing a fake image with symbols: ai where i is the pixel identifier
fakeImage = sym('a',[1 h*w]);
fakeImage = reshape(fakeImage,h,w);

%Computing Gradient Matrix
grad_m = gradient(h,w);

%Inspecting how gradient matrix 
%G is mapping pixel values to gradient
gvec= grad_m * fakeImage(:)

% Check that gradient vector is correctly computed
%fake example
mockMatrix = [2 1 3 2;1 4 2 3; 3 5 1 4];
mockMatrix1 = [2 3 3 2;1 5 1 3; 3 2 1 4];
[h,w] = size(mockMatrix);
G= gradient(h,w);
ubar = double(reshape(mockMatrix,w*h,1));
ubar1 = double(reshape(mockMatrix1,w*h,1));
ubar = [ubar ubar1 ubar];
%obtained
gCode = (G * ubar);
%manually calculated
g0 = 0.5*[-1 2 -1 3 -2 1 2 -4 3 1 -2 -3 -1 1 1 -1 -1]';
g1 = 0.5*[1 0 -1 4 -4 2 -1 -1 3 1 -2 -2 3 2 0 -1 -1]';
gManual = [g0 g1 g0];

%Test that gradient vector computed manually is the same as the one yielded
%by using the code
testCase = matlab.unittest.TestCase.forInteractiveUse;
assertEqual(testCase,gCode,gManual);

%Test that for cs=1, the output image is the same as the output:
%Original image in vector representation
image=imread('blurryImage.png');
[h w d]=size(image);
Ubar = double(reshape(image,w*h,d))/255;
%output image
out_image = sharpening('blurryImage.png','noscal.png',1,0.5);
Unoscal = double(reshape(out_image,w*h,d))/255;

%Check that output image is equal to the input image
assertEqual(testCase,Unoscal,Ubar,'AbsTol',0.01)
