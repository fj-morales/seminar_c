%Test for correctness
%Gradient Matrix
h = 3;
w = 4;
%Producing a fake image with symbols: ai where i is the pixel identifier
fakeImage2 = sym('a',[1 h*w]);
fakeImage2 = reshape(fakeImage2,h,w);
selection = [0 1 0 0; 1 1 1 1; 0 1 1 0];
% selection = ones(3,4);
% selection = [1 1 0 0; 1 1 1 1; 0 1 1 0];
% selection = [0 1 1 0; 1 1 1 1; 1 1 1 1; 0 1 1 0];
U = sym('a',[h*w 1]);
[G, g_zeros] = gradient(selection);
g = G*U;
g(g_zeros == 1) = 0