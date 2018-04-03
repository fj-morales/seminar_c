function [ G, g_zeros ] = gradient( selection )
%GRADIENT Gradient matrix computation
%   This function takes an image or binary area selection 
%   and computes the gradient (G) matrix.
%   Input: rectangular or irregular selection or image
%   Output: gradient matrix G, g_zeros (indexes of boundary pixels)

%%
% Determining if input is image or binary selection
selection = double(selection);
if (sum(sum(and(selection ~=0,selection ~=1))) > 1) % check if input is rectangular or irregular
    sel_area_red = logical(selection); % it's an image, not binary selection
    isRectangle = true;
else
    sel_area_red = selection(any(selection(:,1:end),2),:); % remove zero rows
    sel_area_red = sel_area_red(:,any(sel_area_red(:,1:end),1)); % remove zero rows
    isRectangle = false;
end
sel_ind=[];
[sel_ind(:,1), sel_ind(:,2)]= find(sel_area_red == 1);

h_sel = size(sel_area_red,1);
w_sel = size(sel_area_red,2);   

%% G computation optimized for rectangular selections
if (isRectangle) 
    G_w = w_sel*h_sel; % G Width
    G_h = h_sel*(w_sel-1)+(h_sel-1)*w_sel; % G height
    G_i = repmat([1:G_h],2,1);
    G_i= G_i(:);
    G_v = [repmat([-1 1], 1, h_sel*(w_sel-1)) repmat([1 -1], 1, (h_sel-1)*w_sel)]';
    G_j = [];
   % Compute horizontal gradients
    if (w_sel>1)
        r_edge = [];
        for i=1:h_sel
            r_edge = (w_sel-1)*h_sel+i;
            G_j = [G_j; i];
            row_jump = i;
            while(row_jump < r_edge-h_sel)
                row_jump = row_jump + h_sel;
                G_j = [G_j; row_jump; row_jump];      
            end
            G_j = [G_j; r_edge];
        end
    end

    % Compute vertical gradients
    if (h_sel>1)
        c_edge = 0;
        for i=1:h_sel:G_w
            c_edge = c_edge + h_sel;
            G_j = [G_j; i];
            col_jump = i;
            while(col_jump < c_edge-1)
                col_jump = col_jump + 1;
                G_j = [G_j; col_jump; col_jump];      
            end
            G_j = [G_j; c_edge];
        end
    end
    % collect triplets here
    G = sparse(G_i,G_j,G_v);

%% G computation for irregular selection
else
    sel_ind_bound = cell2mat(bwboundaries(selection)); %boundary idx in 2d format
    % %%
    G_v = [];
    G_i = [];
    G_j = [];
    g_zeros = [];
    h=waitbar(0,'Computing gradient, please wait...');
    loopend=max(sel_ind(:,1))+max(sel_ind(:,2));
    waitbar_counter = 0;
    % Compute horizontal gradients
    for i=1:max(sel_ind(:,1))
        j_ind = sel_ind(sel_ind(:,1)==i, 2); % Returns all the j colums for ith-row

        for j=min(j_ind):max(j_ind)
             if(ismember(j+1,j_ind)) % is required neighbor part of the line vector?

                G_j = [G_j;i+(j-1)*h_sel;i+j*h_sel];
                G_v = [G_v; -1; 1];
                if (ismember([i j], sel_ind_bound, 'rows') || ismember([i j+1], sel_ind_bound, 'rows')) % is the current pixel or its neighbor part of the boundary?
                    g_zeros = [g_zeros; 1];
                else
                   g_zeros = [g_zeros; 0]; 
                end
             end
        end
        waitbar_counter = waitbar_counter + 1;
        waitbar(waitbar_counter/loopend,h);
    end
    % Compute vertical gradients
    for j=1:max(sel_ind(:,2))
        i_ind = sel_ind(sel_ind(:,2)==j, 1); %

        for i=min(i_ind):max(i_ind)
            if(ismember(i+1,i_ind))

                G_j = [G_j;i+(j-1)*h_sel;i+(j-1)*h_sel+1];
                G_v = [G_v; 1; -1];
                if (ismember([i j], sel_ind_bound, 'rows') || ismember([i+1 j], sel_ind_bound, 'rows')) % is the current pixel or its neighbor part of the boundary?
                    g_zeros = [g_zeros; 1];
                else
                   g_zeros = [g_zeros; 0]; 
                end
            end
        end
        waitbar_counter = waitbar_counter + 1;
        waitbar(waitbar_counter/loopend,h);
    end
    delete(h);
    G_i = repmat([1:length(G_j)/2],2,1);
    G_i = G_i(:);
    G = sparse(G_i,G_j,0.5*G_v,size(G_v,1)/2,h_sel*w_sel);
end
