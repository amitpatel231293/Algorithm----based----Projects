
clear all
close all
clc

opts.BlockSize   = 2;
opts.SearchLimit = 30;
img0 = im2double(imread('imgs/m1.png'));
img1 = im2double(imread('imgs/m2.png'));

tic
[MVx1,MVy1] = Estmating_motion(img0, img1, opts);
[MVx2,MVy2] = Estmating_motion(img1, img0, opts);
MVx(:,:,1) =  MVx1;
MVx(:,:,2) = -MVx2;
MVy(:,:,1) =  MVy1;
MVy(:,:,2) = -MVy2;
MVx = max(MVx, [], 3);
MVy = max(MVy, [], 3);
toc

tic
pel= 0.5;
img = imresize(img0, 1/pel, 'bilinear');
BlockSize  = floor(size(img,1)/size(MVx,1));
[m n C]    = size(img);
M          = floor(m/BlockSize)*BlockSize;
N          = floor(n/BlockSize)*BlockSize;
f          = img(1:M, 1:N, 1:C);
g          = zeros(M, N, C);

MVxmap = imresize(MVx, BlockSize);
MVymap = imresize(MVy, BlockSize);
Dx = round(MVxmap*(1/pel));
Dy = round(MVymap*(1/pel));
[xgrid,ygrid] = meshgrid(1:N, 1:M);
X = min(max(xgrid+Dx, 1), N);
Y = min(max(ygrid+Dy, 1), N);
idx = (X(:)-1)*M + Y(:);
for coloridx = 1:C
    fc = f(:,:,coloridx);
    g(:,:,coloridx) = reshape(fc(idx), M, N);
end
g = imresize(g, pel);
imgMC = g;
[rowsA,colsA,numberOfColorChannelsA] = size(img0);
[rowsB,colsB,numberOfColorChannelsB] = size(imgMC);
if rowsB ~= rowsA || colsA ~= colsB
    imgMC = imresize(imgMC, [rowsA colsA]); 
end


toc
[M,N,C] = size(imgMC);
Res  = imgMC-img1(1:M, 1:N, 1:C);
MSE  = norm(Res(:), 'fro')^2/numel(imgMC);
PSNR = 10*log10(max(imgMC(:))^2/MSE);
figure(1);
quiver(MVx(end:-1:1,:), MVy(end:-1:1,:));
title('Motion Vector Field');
figure(2);
subplot(221);
imshow(img0); title('img_0');
subplot(222);
imshow(img1); title('img_1');
imwrite(imgMC,'imgs/Motion_gen.png','png')
subplot(223);
imshow(imgMC); title('img_M');
subplot(224); 
T = sprintf('img_M - img_1, PSNR %3g dB', PSNR);
imshow(rgb2gray(imgMC)-rgb2gray(img1(1:M, 1:N, :)), []); title(T);

clc

imagename1='imgs/m1.png';
imagename2='imgs/Motion_gen.png';
namevid ='Generated_output/myfile1.avi';

interpolation_videogen

imagename1='imgs/Motion_gen.png';
imagename2='imgs/mm.png';
namevid ='Generated_output/myfile2.avi';

interpolation_videogen

imagename1='imgs/mm.png';
imagename2='imgs/m2.png';
namevid ='Generated_output/myfile3.avi';

interpolation_videogen

outst1 ='Generated_output/myfile1.avi';
namevid ='Generated_output/myfile2.avi';

vidobj1=VideoReader(outst1);
vidobj2=VideoReader(namevid);
frames1=vidobj1.NUmberofframes;
frames2=vidobj2.Numberofframes;
no=0;
for f1 = 1 :frames1
    no=no+1;
    thisframe1 = read(vidobj1, f1);
    %imshow(thisframe1);
    output_video(:,:,:,f1) = thisframe1;
end

for f1 = 1 :frames2
    thisframe2 = read(vidobj2, f1);
    output_video(:,:,:,no+f1) = thisframe2;
    %imshow(thisframe2);
end

implay(output_video);
A = output_video;
v = VideoWriter('Generated_output/out1.avi');
open(v)
writeVideo(v,A)
close(v)

outst1 ='Generated_output/myfile2.avi';
namevid ='Generated_output/myfile3.avi';

vidobj1=VideoReader(outst1);
vidobj2=VideoReader(namevid);
frames1=vidobj1.NUmberofframes;
frames2=vidobj2.Numberofframes;
no=0;
for f1 = 1 :frames1
    no=no+1;
    thisframe1 = read(vidobj1, f1);
    %imshow(thisframe1);
    output_video(:,:,:,f1) = thisframe1;
end

for f1 = 1 :frames2
    thisframe2 = read(vidobj2, f1);
    output_video(:,:,:,no+f1) = thisframe2;
    %imshow(thisframe2);
end

implay(output_video);
A = output_video;
v = VideoWriter('Generated_output/out2.avi');
open(v)
writeVideo(v,A)
close(v)

outst1 ='Generated_output/out1.avi';
namevid ='Generated_output/out2.avi';

demo

vidobj1=VideoReader(outst1);
vidobj2=VideoReader(namevid);
frames1=vidobj1.NUmberofframes;
frames2=vidobj2.Numberofframes;
no=0;
for f1 = 1 :frames1
    no=no+1;
    thisframe1 = read(vidobj1, f1);
    %imshow(thisframe1);
    output_video(:,:,:,f1) = thisframe1;
end

for f1 = 1 :frames2
    thisframe2 = read(vidobj2, f1);
    output_video(:,:,:,no+f1) = thisframe2;
    %imshow(thisframe2);
end

implay(output_video);
A = output_video;
v = VideoWriter('Final_Animation.avi');
open(v)
writeVideo(v,A)
close(v)

