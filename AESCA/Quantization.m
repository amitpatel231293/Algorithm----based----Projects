clc;
clear all;
 
% Set the no of colors to flex your image in that many colors
num_of_colors =7;
dar_index = 1.4; 

%taking Artistic image as a source image
[Image_matrix, image_mapp] = imread('input.jpg');
matrix_size = size(Image_matrix);
maping_size = size(image_mapp);

if(maping_size(1) == 0)
    input_image = Image_matrix;
else
    input_image = ind2rgb(Image_matrix, image_mapp);
    input_image = round(input_image .* 255); 
end

%Running K-Means
red_p = input_image(:,:,1);
green_p = input_image(:,:,2);
blue_p = input_image(:,:,3);
new_frame = zeros((matrix_size(1) * matrix_size(2)), 3);
new_frame(:,1) = red_p(:);
new_frame(:,2) = green_p(:);
new_frame(:,3) = blue_p(:);
new_frame1 = double(new_frame);

[mat_index, matrix_c] = kmeans(new_frame, num_of_colors, 'EmptyAction', 'singleton');
Avg_plates = round(matrix_c);

%Mapping colors
mat_index = uint8(mat_index);
output_image = zeros(matrix_size(1),matrix_size(2),3);
tem = reshape(mat_index, [matrix_size(1) matrix_size(2)]);

for i = 1 : 1 : matrix_size(1)
    for j = 1 : 1 : matrix_size(2)
        output_image(i,j,:) = Avg_plates(tem(i,j),:);
    end
end

%Writting Output Image file
outFilename = ['Cartoonified_Image', '_', int2str(num_of_colors), '.jpg'];
imwrite(uint8(output_image), outFilename);
A = uint8(output_image);

edge = imread('edge','jpg');
rgbimage=A;
e= edge;
mask = e;
b = rgbimage;
[m,n]=size(b);

c = imfuse(b,mask,'blend','Scaling','joint');

 
image_d = im2double(c); 
avg = mean2(image_d);
disp(avg)
sigma = std2(image_d);
disp(sigma)
colored_img = imadjust(image_d,[avg-dar_index*sigma,avg+dar_index*sigma],[]);
figure();imshow(colored_img);title('Final Cartoonified image with edges');
output='Cartoonified_image_with_edges.jpg';
imwrite(colored_img, output);

