clc;
close all;

name='input.jpg';
%img1 = bilateralFilter(name);
figure();imshow(name);title('main');
A = imread('smoothing','jpg');
%B = fspecial('average',[5,5]);
figure();imshow(A);title('Artistic Image');
edge = imread('edge','jpg');
figure();imshow(edge);title('edges');


rgbimage=A;
e= edge;
mask = e;
b = rgbimage;
[m,n]=size(b);

c = imfuse(b,mask,'blend','Scaling','joint');
%output (:,:,3) = rgbimage(:,:,3) .* mask;
%output (:,:,2) = rgbimage(:,:,2) .* mask;
%output (:,:,1) = rgbimage(:,:,1) .* mask;
%
%bIn3Dims = repmat(b,1,1,3);
%maskedRgbImage = bsxfun(@times, rgbimage, cast(mask, 'like', rgbimage));
% for i=1:m
 %        if (b(i)==0)
  %   maskedRgbImage(i,:)=rgbimage(i,:);
   %      end
 %end
n = 1.2;
image_d = im2double(c); 
avg = mean2(image_d);
disp(avg)
sigma = std2(image_d);
disp(sigma)
colored_img = imadjust(image_d,[avg-n*sigma,avg+n*sigma],[]);
figure();imshow(colored_img);title('Artistic Image with edges');
output='Artistic.jpg';
imwrite(colored_img, output);
% final=c+A;
%figure();imshow(final);