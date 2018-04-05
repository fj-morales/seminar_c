clear all;
clc;
% Loading image data
im_source= [0 0 0 0 0 0 0 0;
    0 1 1 1 1 1 1 0;
    0 1 0 0 0 0 1 0;
    0 1 0 0 0 0 1 0;
    0 1 0 0 0 0 1 0;
    0 1 0 0 0 0 1 0;
    0 1 1 1 1 1 1 0;
    0 0 0 0 0 0 0 0];
im_target = 1 - im_source;
[h w d]=size(im_source);

rect = true;
% Source image area selection
% Rectangular selection if rect = true
% Free-hand selection if rect = false
imshow(im_source)
title('Please select region in source image');

if (rect == true)
    h_im = imrect;
else
    h_im = imfreehand;
end

% Extraction of inner and boundary indexes
sel_area = round(h_im.createMask); % selected area
b_idx = cell2mat(bwboundaries(sel_area));
b_idx = b_idx(1:length(b_idx)-1,:);
UL = [min(b_idx(:,1)) min(b_idx(:,2))]; % Upper Left corner 
BR = [max(b_idx(:,1)) max(b_idx(:,2))]; % Bottom Right corner 
BL = [max(b_idx(:,1)) min(b_idx(:,2))]; % Bottom Left corner 
UR = [min(b_idx(:,1)) max(b_idx(:,2))]; % Upper Right corner 
h_s=(BR(1)-UL(1)+1);
w_s=(BR(2)-UL(2)+1);
b_idx_shift = b_idx - [min(b_idx(:,1))-1 min(b_idx(:,2))-1];
Ub_idx = sub2ind([h_s w_s], b_idx_shift(:,1), b_idx_shift(:,2));
St = sparse(Ub_idx(1:length(Ub_idx)),[1:length(Ub_idx)],ones(length(Ub_idx),1),h_s*w_s,length(Ub_idx));
close;

% Gradient matrix for inner and boundary pixels construnction
disp('Computing gradient, please wait...')
[G,g_zeros ]= gradient(sel_area);
disp('Gradient computation finished!')

% Uinner vector creation from selected area
c = find (sel_area == 1);
[aa, bb, dd] = ind2sub(size(sel_area),c);
inner_idx_shift  = [aa bb] -[min(aa)-1 min(bb-1)];
pad_idx = sub2ind([h w], repmat(UL(1):BL(1),1,w_s), repelem(UL(2):UR(2),h_s));
Uinner = double(im_source(pad_idx'))/255; 

% Gradient computation of selected area in vector form
g = G * Uinner;
% Setting boundary gradients to zero
g(g_zeros == 1) = 0;

% Selecting the point where the source selection will be 
% inserted on the target image
warning('off', 'Images:initSize:adjustingMag');
figure
imshow(im_target)  
title('Click on a point to insert the blended image')
h_im = impoint;
position = round(h_im.getPosition);
position = fliplr(position);

% Creation of Ub vector from boundary pixels from target image
target_bidx = position + b_idx_shift - 1;
target_bidx
idx = sub2ind(size(im_target), target_bidx(:,1), target_bidx(:,2));
Ub = double(im_target(idx))/255;
close;
