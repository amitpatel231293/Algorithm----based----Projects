clc;
close all;

Threshold=0.02;

name='input.jpg';
img = double(imread(name))/255;
figure();imshow(img);title('main');
A = imread('smoothing','jpg');
size(A);
grayed = rgb2gray(A);
size(grayed);
A = im2double(grayed);
avg = fspecial('average',[5,5]);
Den = conv2(A,avg,'same');
Q = A-Den;
N = size(Q);
% replacing pixels based on threshold
for i = 1:N(1)
for j = 1:N(2)
    if Q(i,j)> Threshold
    Q(i,j) = 0;
    else
    Q(i,j) = 1;
    end
end
end
V = fspecial('average',[1,1]);
F_img = conv2(Q,V,'same');
figure();
imshow(F_img);
size(F_img);
output='edge.jpg';
imwrite(F_img, output);




    