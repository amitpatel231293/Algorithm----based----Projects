%load Y_Matrix
%load X_Matrix
% Change lambda by Lam variable
function Task1_testFull_L1_YaleB_demo(d,isRandom,verbosity)
if nargin<1
    isRandom = 1;
    verbosity = 1;
    d = 300;
end
close all
clc
Lam=10000;
t_offline = 0;
t_est = [];
t_check = [];
acc = 0;

directory = './data/CroppedYale/';

%------- read data--------------------------------
%-------------------------------------------------
fprintf('----------------------------------\nL1 for face recognition \n');
fprintf('----------------------------------\n Read data ... \n');

persons = [1:13,15:39];% there is no image for the 14-th person in Extended YaleB
L = []; % labels;
cnts = [];
isFirst = 1;
for p = persons
    if(p<10)
        str_p = ['0',num2str(p)];
    else
        str_p = num2str(p);
    end
    D = dir([directory,'yaleB' ,str_p]);
    cnt = 0;
    for i = 1:length(D),
        [pathstr, name, ext] = fileparts(D(i).name);
        if ((~(D(i).isdir))&&strcmpi(ext, '.pgm')&&(~length(strfind(name, 'Ambient'))))
            if(isFirst)
                filename = [directory,'yaleB' ,str_p, '/',D(i).name];
                im = imread(filename);
                [height,width] = size(im);
            end
            isFirst = 0;
            cnt = cnt+1;
        end
    end
    cnts(end+1) = cnt;
end
num_im = min(cnts);
%num_im = 10;


%---- split the data------------------------------
%-------------------------------------------------
fprintf('----------------------------------\n Split data into \n train and test sets ... \n');
per = length(persons);
num = floor(num_im/2); % use equal size training and testing sets. Not neccessary.
s = 0;
if(isRandom == 1)
    rand('seed',s);
    order = randperm(2*num);
else
    order = 1:2*num;
end

X = zeros(height*width,per*num);% training images
Y = zeros(height*width,per*num);% testing images
current = zeros(height*width,2*num); % for one person


for p = persons
    if(p<10)
        str_p = ['0',num2str(p)];
    else
        str_p = num2str(p);
    end
    D = dir([directory,'yaleB' ,str_p]);
    cnt = 0;
    for i = 1:length(D),
        [pathstr, name, ext] = fileparts(D(i).name);
        if ((~(D(i).isdir))&&strcmpi(ext, '.pgm')&&(cnt<2*num)&&(~length(strfind(name, 'Ambient'))))
            cnt = cnt+1;
            filename = [directory,'yaleB' ,str_p, '/',D(i).name];
            im = imread(filename);
            %imshow(im);
            %title([num2str(cnt),'-th face for ', num2str(p),'-th person' ])
            L(end+1) = p;
            current(:,cnt) = reshape(im,height*width,1);
        end
        
    end
    
    if(p<14)
        p2 = p;
    else
        p2 = p-1;
    end
    fprintf([num2str(p2),'-th person\n'])
    
    X(:,(p2-1)*num+1:p2*num) = current(:,order(1:num));
    Y(:,(p2-1)*num+1:p2*num) = current(:,order(num+1:end));
    
    
end




%------- recognise faces--------------------------
%-------------------------------------------------

% These lines takes up to a minute, this is an off-line step though.
% But it can be made much faster, not optimised.

% These lines takes up to a minute, this is an off-line step though.
% But it can be made much faster, not optimised.
fprintf('----------------------------------\northonlise faces Offline ...\n')
tic
%Aq=orth(X);
%Q=inv(Aq'*X);


    %d = 2^13;
    dim = size(X,1);
    %stream = RandStream('mlfg6331_64','RandnAlg','Polar');
    %R = randn(stream,d,dim);
    
    rng(111,'twister');
    R = randn(d,dim);
    mat_phi = R*X;
    RY = R*Y;

t_offline = toc;

%tic
%XUT2=C*Y;
%t_est = toc;
%save('L2solution','XUT2','X','Y');


IND2=[]; pct=[];
%%
num_test = size(Y,2);


fprintf('----------------------------------\nTesting ...\n');

for i=1:num_test
    if(mod(i,100)==0)
        fprintf('----------------------------------\nFace: %d \n',i);
    end
    
    y = RY(:,i);
    
    [x] = feature_sign(X, Y(:,i), Lam);
  
   
    [ind2,ssdist2]=checkperson_YaleB_demo(X,x,Y(:,i),per,num);
%    function [ind,ssdist]=checkperson_YaleB_demo(A,x,y,pers,impp)

    
    
    IND2(i)=ind2;
    
    if(verbosity == 1)
        pct(i)=sum([(floor(((1:i)-1)/num)+1)'==IND2'])/i;
        
        fprintf('Predicted face id: %d \nCorrect face id: %d \n',ind2,floor((i-1)/num)+1);
        fprintf('Recognition rate : %f \n\n' ,pct(end) )
    end
end
acc=sum([(floor(((1:num_test)-1)/num)+1)'==IND2'])/i;


fprintf('----------------------------------\n\n    Report \n\nRuntime(seconds) offline:%g,estimation:%g,checkID:%g\n',t_offline,sum(t_est),sum(t_check));
fprintf('Recognition Rate:%g\n',acc);
end