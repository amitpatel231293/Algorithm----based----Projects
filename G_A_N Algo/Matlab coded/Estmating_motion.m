
function [MVx,MVy] = Estmating_motion(tima, reimg, pt)
% Set default values
if ~isfield(pt,'BlockSize')
    pt.BlockSize = 10;
end

if ~isfield(pt,'SearchLimit')
    pt.SearchLimit = 20;
end
BlockSize   = max(pt.BlockSize,   6);
SearchLimit = max(pt.SearchLimit, 6);

if mod(BlockSize,2)~=0
    error('it is better to have BlockSize = even number');
end
if mod(SearchLimit,2)~=0
    error('it is better to have SearchLimit = even number');
end

% Crop the images so that image size is a multiple of BlockSize
M        = floor(size(reimg, 1)/BlockSize)*BlockSize;
N        = floor(size(reimg, 2)/BlockSize)*BlockSize;
reimg  = reimg(1:M, 1:N, :);
tima = tima(1:M, 1:N, :);


% Enlarge the image boundaries by BlockSize/2 pixels
reimg  = padarray(reimg,  [BlockSize/2 BlockSize/2], 'replicate');
tima = padarray(tima, [BlockSize/2 BlockSize/2], 'replicate');

% Pad zeros to images to fit SearchLimit
reimg  = padarray(reimg,  [SearchLimit, SearchLimit]);
tima = padarray(tima, [SearchLimit, SearchLimit]);


% Set parameters
[M N C]     = size(reimg);
L           = floor(BlockSize/2);
BlockRange  = -L:L-1;
xc_range    = SearchLimit+L+1 : BlockSize : N-(SearchLimit+L);
yc_range    = SearchLimit+L+1 : BlockSize : M-(SearchLimit+L);

MVx = zeros(length(yc_range), length(xc_range));
MVy = zeros(length(yc_range), length(xc_range));


% Main Loop
for i = 1:length(yc_range)
    for j = 1:length(xc_range)
        xc = xc_range(j);
        yc = yc_range(i);
        
        Block           = tima(yc + BlockRange, xc + BlockRange, :);
    
        [MVy1,MVx1]     = Logdet(Block, reimg, xc, yc, SearchLimit);
        
        MVx(i,j) = MVx1;
        MVy(i,j) = MVy1;
    end
end

MVx(MVx> SearchLimit) =  SearchLimit;
MVx(MVx<-SearchLimit) = -SearchLimit;
MVy(MVy> SearchLimit) =  SearchLimit;
MVy(MVy<-SearchLimit) = -SearchLimit;
MVx = medfilt2(MVx, [3 3]);
MVy = medfilt2(MVy, [3 3]);
