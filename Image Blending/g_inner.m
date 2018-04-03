function [ g_inner ] = g_inner(g, h, w );
%%
gs1 = (w-1)*h;
gs2 = (h-1)*w;
g(1:w-1,:) = 0;
g(gs1-w+1:gs1,:)=0;
g(gs2:gs2+h-1,:)=0;
g(gs1+gs2-h+1:gs1+gs2,:)=0;

for k=w-1:w-1:gs1
    g(k+1,:) = 0;
    g(k,:) = 0;
end
g(gs1+1,:) = 0;
for k=gs1-1+h:h-1:gs2+gs1
    g(k,:) = 0;
    if(k+1<=gs2+gs1)
        g(k+1,:) = 0;
    end
end
g_inner = g;