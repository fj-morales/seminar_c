function [g_holy] = g_holy(g, b_idx, inner_idx, h_s, w_s)

g_holy = [];
for i = 1:size(inner_idx,1)
    % checking if the inner index is a boundary index; if yes setting the
    % gradient to zero
    if(ismember(inner_idx(i,:), b_idx, 'rows'))
        %if they are either in first row and first column then they only
        %have  one corresponding gradient value
        if(inner_idx(i,1) ==1 || inner_idx(i,2)==1)
            g_holy = [g_holy;0];
        %otherwise they have two corresponding gradient values
        else
            g_holy = [g_holy;0;0];
        end
    else
        gVal = mapG(g, inner_idx(i,:), h_s, w_s);
        g_holy = [g_holy; gVal];
    end
end

