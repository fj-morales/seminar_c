function [ G, g_zeros ] = gradient( selection )
%GRADIENT Gradient matrix computation
%   This function takes an image or binary area selection 
%   and computes the gradient (G) matrix.
%   Input: rectangular or irregular selection or image
%   Output: gradient matrix G, g_zeros (indexes of boundary pixels)

%%
% Determining if input is image or binary selection
selection = double(selection);
if (sum(sum(and(selection ~=0,selection ~=1))) > 1) % check if input is image or selection
    sel_area_red = logical(selection); % it's an image
    isRectangle = true; % then, it's rectangular
else 
    % It's selection, then remove zero rows and columns
    sel_area_red = selection(any(selection(:,1:end),2),:); % remove zero rows
    sel_area_red = sel_area_red(:,any(sel_area_red(:,1:end),1)); % remove zero rows
    sel_ind_bound = cell2mat(bwboundaries(selection)); %boundary idx in 2d format
    if(ismember(0,sel_area_red)) % check if selection is rectangular or irregular
        isRectangle = false;
    else
        isRectangle = true;
    end
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
    G_v = 0.5*[repmat([-1 1], 1, h_sel*(w_sel-1)) repmat([1 -1], 1, (h_sel-1)*w_sel)]';
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

    g_zeros = zeros((w_sel-1)*h_sel + (h_sel-1)*w_sel,1);
    gs1 = (w_sel-1)*h_sel;
    gs2 = (h_sel-1)*w_sel;
    g_zeros(1:w_sel-1,:) = 1;
    g_zeros(gs1-w_sel+1:gs1,:)=1;
    g_zeros(gs2:gs2+h_sel-1,:)=1;
    g_zeros(gs1+gs2-h_sel+1:gs1+gs2,:)=1;

    for k=w_sel-1:w_sel-1:gs1
        g_zeros(k+1,:) = 1;
        g_zeros(k,:) = 1;
    end
    g_zeros(gs1+1,:) = 1;
    for k=gs1-1+h_sel:h_sel-1:gs2+gs1
        g_zeros(k,:) = 1;
        if(k+1<=gs2+gs1)
            g_zeros(k+1,:) = 1;
        end
    end
    
%% G computation for irregular selection
else

    % %%
    G_v = [];
    G_i = [];
    G_j = [];
    h=waitbar(0,'Computing gradient, please wait...');
    loopend=max(sel_ind(:,1))+max(sel_ind(:,2));
    waitbar_counter = 0;
    g_zeros = [];
    % Compute horizontal gradients
    for i=1:max(sel_ind(:,1))
        
        j_ind = sel_ind(sel_ind(:,1)==i, 2); % Returns all the j colums for ith-row

        for j=min(j_ind):max(j_ind)
             if(ismember(j+1,j_ind)) % is required neighbor part of the horizontal line vector?

                if(ismember([i j], sel_ind_bound, 'rows') && ismember([i j+1], sel_ind_bound, 'rows')) % is the current pixel or its neighbor part of the boundary?
                    % If both boundary pixels, do nothing
                else
                    G_j = [G_j;i+(j-1)*h_sel;i+j*h_sel];
                    G_v = [G_v; -1; 1];
                    if(ismember([i j], sel_ind_bound, 'rows') || ismember([i j+1], sel_ind_bound, 'rows')) % is the current pixel or its neighbor part of the boundary?
                       g_zeros = [g_zeros; 1];
                    else
                       g_zeros = [g_zeros; 0]; 
                    end
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
            if(ismember(i+1,i_ind)) % is required neighbor part of the vertical line vector?

                if (ismember([i j], sel_ind_bound, 'rows') && ismember([i+1 j], sel_ind_bound, 'rows'))
                    % If both boundary pixels, do nothing
                else
                    G_j = [G_j;i+(j-1)*h_sel;i+(j-1)*h_sel+1];
                    G_v = [G_v; 1; -1];
                    if (ismember([i j], sel_ind_bound, 'rows') || ismember([i+1 j], sel_ind_bound, 'rows')) % is the current pixel or its neighbor part of the boundary?
                        g_zeros = [g_zeros; 1];
                    else
                        g_zeros = [g_zeros; 0]; 
                    end 
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
