% 
%
%   Demonstrates fast L2 algorithm for face recognition on Extended YaleB dataset 
%    
%   d --- the reduced dimension using fast check id trick
%   isFastCheckID --- 1 uses the fast check id trick, 0 not use the trick
%   isRandom --- if split the data randomly, 
%
%   See the following paper for detail
%   [1] Qinfeng Shi, Anders Eriksson, Anton van den Hengel, Chunhua Shen, 
%   Is face recognition really a Compressive Sensing problem? CVPR 11, Colorado Springs, USA, June 21-23, 2011. 
%
%   May 2011, Qinfeng (Javen) Shi  qinfeng.shi@ieee.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Task2_testFull_L2_YaleB_fastcheckid_demo(d,isFastCheckID,isRandom,verbosity)
if nargin<1
    isFastCheckID = 1;
    isRandom = 1;
    verbosity = 0;
    d = 64;
end
close all
clc
Lam =100000000;
t_offline = 0;
t_est = 0;
t_check = [];
acc = 0;

directory = './data/CroppedYale/';

%------- read data--------------------------------
%-------------------------------------------------
fprintf('----------------------------------\nL2 for face recognition \n');
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
%num_im = 10; % set a value if you want to use a subset of faces.


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
current = zeros(height*width,2*num); % temporary faces for one person


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
fprintf('----------------------------------\northonlise faces Offline ...\n')
tic
%Aq=orth(X);
%Q=inv(Aq'*X);
[Aq,Q]=qr(X,0);

T=transpose(Q)*Q;
IL=eye(size(T));
mainin=inv(T+(Lam*IL));
Q=mainin*transpose(Q);
%Q=pinv(Q);
C = Q*Aq';
gan=sprintf('%d ', C);
fprintf('Answer: %s\n', gan)
%w=size(X,2);
%resid = Y(:,i) - X*w;
%garn=sprintf('%d ', resid);
%fprintf('Answer: %s\n', garn)
%C = fmincon(@(w)norm(resid)^2 + 2*norm(w)^2,rand(w,1));
%gan=sprintf('%d ', C);
%fprintf('Answer: %s\n', gan)
if(isFastCheckID)
    %d = 2^13;
    dim = size(X,1);
    %stream = RandStream('mlfg6331_64','RandnAlg','Polar');
    %R = randn(stream,d,dim);
    
    rng(111,'twister');
    R = randn(d,dim);
    mat_phi = R*X;
    RY = R*Y;
end
t_offline = toc;

tic
XUT2=C*Y;
t_est = toc;
%save('L2solution','XUT2','X','Y');


IND2=[]; pct=[];
%%
num_test = size(Y,2);


fprintf('----------------------------------\nTesting ...\n');
for i=1:num_test
    if(mod(i,100)==0)
        fprintf('Face: %d \n',i);
    end
    
    tic
    if(isFastCheckID)
        [ind2,ssdist2]=checkperson_YaleB_demo(mat_phi,XUT2(:,i),RY(:,i),per,num);
    else
        [ind2,ssdist2]=checkperson_YaleB_demo(X,XUT2(:,i),Y(:,i),per,num);
    end
    tmp = toc;
    t_check(end+1) = tmp;
    
    IND2(i)=ind2;
    
    if(verbosity == 1)
        pct(i)=sum([(floor(((1:i)-1)/num)+1)'==IND2'])/i;
        
        fprintf('Predicted face id: %d \nCorrect face id: %d \n',ind2,floor((i-1)/num)+1);
        fprintf('Recognition rate : %f \n\n' ,pct(end) )
    end
end
acc=sum([(floor(((1:num_test)-1)/num)+1)'==IND2'])/i;


fprintf('----------------------------------\n\n    Report \n\nRuntime(seconds) offline:%g,estimation:%g,checkID:%g\n',t_offline,t_est,sum(t_check));
fprintf('Recognition Rate:%g\n',acc);
end