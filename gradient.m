function [ G ] = gradient( h, w )
%GRADIENT Summary of this function goes here
%   Detailed explanation goes here

%%
 
G_w = w*h; % G Width
G_h = h*(w-1)+(h-1)*w; % G height
ind_i = repmat([1:G_h],2,1);
ind_i= ind_i(:);
val = [repmat([-1 1], 1, h*(w-1)) repmat([1 -1], 1, (h-1)*w)]';
ind_j = [];

% Compute the first part of g vector
if (w>1)
    r_edge = [];
    for i=1:h
        r_edge = (w-1)*h+i;
        ind_j = [ind_j; i];
        row_jump = i;
        while(row_jump < r_edge-h)
            row_jump = row_jump + h;
            ind_j = [ind_j; row_jump; row_jump];      
        end
        ind_j = [ind_j; r_edge];
    end
end

% Compute the second part of g vector
if (h>1)
    c_edge = 0;
    for i=1:h:G_w
        c_edge = c_edge + h;
        ind_j = [ind_j; i];
        col_jump = i;
        while(col_jump < c_edge-1)
            col_jump = col_jump + 1;
            ind_j = [ind_j; col_jump; col_jump];      
        end
        ind_j = [ind_j; c_edge];
    end
end
% collect triplets here
G = sparse(ind_i,ind_j,val);


