function [MVy,MVx] = Logdet(bl, im2, xx, cy, lim)

[M,N,C]       = size(im2);
BlockSize   = size(bl,1);
L           = floor(BlockSize/2);
BlockRange  = -L:L-1;
SADmin      = 1e6;
y_min       = cy;
x_min       = xx;

if (cy<lim+L)||(cy>M-(lim+L))
    error('Can you set yc >%3g pixels from the boundary? \n',lim+L);
end
if (xx<lim+L)||(xx>N-(lim+L))
    error('Can you set xc >%3g pixels from the boundary? \n',lim+L);
end
x0 = xx;
y0 = cy;
LevelMax   = 2;
LevelLimit = zeros(1,LevelMax+1);

for k = 1:LevelMax
    LevelLimit(k+1)             = max(2^(floor(log2(lim))-k+1),1);
    c                           = 2.^(0:log2(LevelLimit(k+1)));
    c(c+sum(LevelLimit(1:k))>lim) = [];
    x_range                     = zeros(1,2*length(c)+1);
    x_range(1)                  = 0;
    x_range(2:2:2*length(c))    = c;
    x_range(3:2:2*length(c)+1)  = -c;
    y_range = x_range;
    for i = 1:length(y_range)
        for j = 1:length(x_range)
            if SADmin>1e-3
                xt = x0 + x_range(j);
                yt = y0 + y_range(i);
                Block_ref  = im2(yt+BlockRange, xt+BlockRange, :);
                SAD        = sum(abs(bl(:) - Block_ref(:)))/(BlockSize^2);
                if SAD < SADmin
                    SADmin  = SAD;
                    x_min   = xt;
                    y_min   = yt;
                end
            else
                SADmin = 0;
                x_min  = xx;
                y_min  = cy;
            end
            
        end
    end
    x0 = x_min;
    y0 = y_min;
end

MVx_int = xx - x_min;
MVy_int = cy - y_min;
Block_ref   = im2(y_min+BlockRange, x_min+BlockRange, :);
Taylor_sol  = Taylor_App(bl, Block_ref);
MVx_frac   = Taylor_sol(1);
MVy_frac   = Taylor_sol(2);
MVx = MVx_int + MVx_frac;
MVy = MVy_int + MVy_frac;
end

function x = Taylor_App(f, g)
[dfx,dfy] = gradient(f);
a = sum(dfx(:).^2);
b = sum(dfx(:).*dfy(:));
d = sum(dfy(:).^2);
z = g-f;
p = sum(z(:).*dfx(:));
q = sum(z(:).*dfy(:));
A = [a b; b d];
rhs = [p;q];
if cond(A)>1e6
    x = [0 0]';
else
    x = A\rhs;
end
end