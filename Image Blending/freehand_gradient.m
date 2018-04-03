 function [ G, g_zeros ] = freehand_gradient( sel_area )
% %%
sel_area = double(sel_area);
if (sum(sum(and(sel_area ~=0,sel_area ~=1))) > 1) % check if area is image or selection
    sel_area_red = logical(sel_area); % it's an image, not binary selection
    %'image'
else
    sel_area_red = sel_area(any(sel_area(:,1:end),2),:); % remove zero rows
    sel_area_red = sel_area_red(:,any(sel_area_red(:,1:end),1)); % remove zero rows
    %'not image, selection!'
end
% %%
h_sel = size(sel_area_red,1);
w_sel = size(sel_area_red,2);

sel_ind=[];
[sel_ind(:,1), sel_ind(:,2)]= find(sel_area_red == 1);

G_h = h_sel*(w_sel-1) + (h_sel-1)*w_sel; % G height
h_sel = size(sel_area_red,1);
w_sel = size(sel_area_red,2);
sel_ind_bound = cell2mat(bwboundaries(sel_area)); %boundary idx in 2d format
% %%
G_v = [];
G_i = [];
G_j = [];
gar = 1; % dummy variable, just for checking purposes, can be removed
g_zeros = [];
for i=1:max(sel_ind(:,1))
    j_ind = sel_ind(sel_ind(:,1)==i, 2); % Returns all the j colums for ith-row
    
    for j=min(j_ind):max(j_ind)
         if(ismember(j+1,j_ind)) % is required neighbor part of the line vector?
             [i j+1];
            G_j = [G_j;i+(j-1)*h_sel;i+j*h_sel];
            G_v = [G_v; -1; 1];
            [gar length(G_j)];% just checking sizes, can be removed
            if (ismember([i j], sel_ind_bound, 'rows') || ismember([i j+1], sel_ind_bound, 'rows')) % is the current pixel or its neighbor part of the boundary?
                g_zeros = [g_zeros; 1];
            else
               g_zeros = [g_zeros; 0]; 
            end
         end

    end
end
gar = 2;
for j=1:max(sel_ind(:,2))
    i_ind = sel_ind(sel_ind(:,2)==j, 1); %
    
    for i=min(i_ind):max(i_ind)
        if(ismember(i+1,i_ind))
            
            G_j = [G_j;i+(j-1)*h_sel;i+(j-1)*h_sel+1];
            G_v = [G_v; 1; -1];
            [gar length(G_j)]; % just checking sizes, can be removed
            if (ismember([i j], sel_ind_bound, 'rows') || ismember([i+1 j], sel_ind_bound, 'rows')) % is the current pixel or its neighbor part of the boundary?
                g_zeros = [g_zeros; 1];
            else
               g_zeros = [g_zeros; 0]; 
            end
        end

    end
end

% g_zeros = []; % this must pad g_zeros till the end. its size must be equal to G_h (=size(G_i,1)/2)
G_i = repmat([1:length(G_j)/2],2,1);
G_i = G_i(:);
G = sparse(G_i,G_j,0.5*G_v,size(G_v,1)/2,h_sel*w_sel);