load('AR_masks');
close all
[dim,n] = size(masks);
figure;
for i = 1:n
    a = masks(:,i);
    b = reshape(a,120,165);
    imshow(uint8(10*b'));
end
