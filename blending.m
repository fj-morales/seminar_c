im_source=imread('croc.jpg');
im_target = imread('target.jpg');
[h w d]=size(im_source);
U = double(reshape(im_source,w*h,d))/255;


%%
im_source =uint8(reshape(U,h,w,d)*255);
figure, imshow(im_source)
% h_im = imfreehand;
h_im = imrect;

sel_area = round(h_im.createMask); % selected area
b_idx = cell2mat(bwboundaries(sel_area));
b_idx = b_idx(1:length(b_idx)-1,:);
UL = [min(b_idx(:,1)) min(b_idx(:,2))]; % Upper Left corner 
BR = [max(b_idx(:,1)) max(b_idx(:,2))]; % Bottom Right corner 
h_s=(BR(1)-UL(1)+1);
w_s=(BR(2)-UL(2)+1);
b_idx_shift = b_idx - [min(b_idx(:,1))-1 min(b_idx(:,2))-1];

Ub_idx = sub2ind([h_s w_s], b_idx_shift(:,1), b_idx_shift(:,2));

St = sparse(Ub_idx(1:length(Ub_idx)),[1:length(Ub_idx)],ones(length(Ub_idx),1),h_s*w_s,length(Ub_idx));

close;
%% Write your gradient method here
G = gradient(h_s,w_s);
c = find (sel_area == 1);
[aa, bb, dd] = ind2sub(size(sel_area),c);
inner_idx = sub2ind([h w], aa, bb);

inner2 = im_source(:,:,2);
inner3 = im_source(:,:,3);
Uinner = double([im_source(inner_idx) inner2(inner_idx) inner3(inner_idx)])/255;

g = G * Uinner;
g_in = g_inner(g,h_s,w_s);

%%

figure, imshow(im_target)
h_im = impoint;
% waitforbuttonpress
position = round(h_im.getPosition);
position = fliplr(position);

target_bidx = position + b_idx_shift;
idx = sub2ind(size(im_target), target_bidx(:,1), target_bidx(:,2));
target2 = im_target(:,:,2);
target3 = im_target(:,:,3);
Ub = double([im_target(idx) target2(idx) target3(idx)])/255;
close;
%%
a = 1;
U_out = (G'*G+a*St*St')\(G'*g_in +a*St*Ub);

%%
image_out =uint8(reshape(U_out,h_s,w_s,d)*255);

new_target = im_target;
[smallRow, smallCol, smallDim] = size(image_out);
row1 = position(1); col1 = position(2);
row2 = row1 + smallRow -1;
col2 = col1 + smallCol -1;

new_target(row1:row2, col1:col2,1) = image_out(:,:,1);
new_target(row1:row2, col1:col2,2) = image_out(:,:,2);
new_target(row1:row2, col1:col2,3) = image_out(:,:,3);

figure, imshow(new_target)
imwrite(image_out,'blended.png')