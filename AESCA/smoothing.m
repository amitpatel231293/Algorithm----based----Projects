clc;
clear all;
close all;

%taking image
name='input.jpg';
img = double(imread(name))/255;

%Prameters
output='smoothing.jpg';
sig=5;
sectors=8;
quan=4;
epsilon = 10^-4;
[hsize, wsize, D] = size(img);

%Creating blank matrices
num = zeros(hsize,wsize,D);
density = zeros(hsize,wsize);

%Creating gaussian kernel
[x,y] = meshgrid(linspace(-wsize/2, wsize/2, wsize), linspace(hsize/2, -hsize/2, hsize));
gaussianKernel = exp( -(x.^2+y.^2) / (2*sig^2) );

%Doing forward transform
for i = 1 : D
    imgw(:,:,i)  = fft2(img(:,:,i));
    img2W(:,:,i) = fft2(img(:,:,i).^2);
end

for i = 0 : sectors-1
    
%multipling with gaussian kernel and weighting functions
    G = advanced_guassian(weight_sec(hsize,wsize, i*2*pi/sectors, pi/sectors), 1, 2.5) .* gaussianKernel;
    G = G / sum(G(:));
%weighting functions to fourier transforming
    G = fft2(G);
    S = zeros(hsize,wsize);
    for k = 1 : D
        m(:,:,k) = ifft2(G .* imgw(:,:,k));
        S = S +    ifft2(G .* img2W(:,:,k)) - m(:,:,k).^2;
    end
%For each channel in color images
    S = (S+epsilon).^(-quan/2);
    density = density + S;
    for k = 1 : D
        num(:,:,k) = num(:,:,k) + m(:,:,k).*S;
    end
   
end

%this part creates output image
for k = 1 : D
    y(:,:,k) = fftshift(num(:,:,k) ./ density);
end

figure();imshow(y);
imwrite(y, output);

% Running advanced guassian function
function gval1 = advanced_guassian(img, sig, n)

rounded = ceil(sig*n);
gaus_value = exp(-[-rounded:rounded].^2/2/sig^2); 
gaus_value = gaus_value/sum(gaus_value);

x = zeros(size(img));
for i = -rounded:rounded
    x = x + circshift(img, [i,0,0]) *gaus_value(i+rounded+1);
end

gval1 = zeros(size(img));
for i = -rounded:rounded
    gval1 = gval1 + circshift(x, [0,i,0]) *gaus_value(i+rounded+1);
end
end

%this part is used for creating sectors
function Sector_var = weight_sec(hsize, wsize, count, wd)

[x,y] = meshgrid(linspace(-wsize/2, wsize/2, wsize), linspace(hsize/2, -hsize/2, hsize));

Sector_var = (x*cos(count-wd+pi/2) + y*sin(count-wd+pi/2) > 0) .* (x*cos(count+wd+pi/2) + y*sin(count+wd+pi/2) <= 0);
end


