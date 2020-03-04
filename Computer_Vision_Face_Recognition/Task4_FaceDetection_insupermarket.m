

Img = imread('super1.jpg');

% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();

main_box = step(faceDetector, Img);

Ibox = insertObjectAnnotation(Img,'Rectangle',main_box,'Identified Face','Color','Green');
figure, imshow(Ibox), title('Detected face');

%J=rgb2gray(Img);
J=Img;
for i=1:size(main_box,1)
    f=J(main_box(i,2):main_box(i,2)+main_box(i,4),main_box(i,1):main_box(i,1)+main_box(i,3));
    f=imresize(f,[192,168]);
    y=double(f(:));
    

    %tarn=transpose(X)*X;
    %[s,l]=size(tarn);
    %IL=eye(s,l);
    %regularizationl2=inv(tarn+(100*IL));
    %Q=regularizationl2*transpose(X);
    %Q=pinv(Q);
    %x_est = Q*y;
    
end
    