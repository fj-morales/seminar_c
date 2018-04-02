function gVal  = mapG(g, idx, h_s, w_s)

gVal = [];

if(idx(2)>1)
    pos = (idx(1)-1)*(w_s-1) + (idx(2)-1);
    gVal = [gVal; g(pos)];
end

% if(idx(2)<w_s)
%     pos = (idx(1)-1)*(w_s-1) + (idx(2));
%     gVal = [gVal; g(pos)];
% end

if(idx(1)>1)
    pos = h_s*(w_s-1) + (idx(2)-1)*(h_s-1)+ idx(1)-1;
    gVal = [gVal; g(pos)];
end

% if(idx(1)<h_s)
%     pos = h_s*(w_s-1) + (idx(2)-1)*(h_s-1)+ idx(1);
%     gVal = [gVal; g(pos)];
% end




