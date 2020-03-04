function [lables,samples]=read_data()
clear      
clc         


dirdata='./Testing_Data';
addpath(dirdata);

%add file path
directory=strcat(dirdata,'/australian_scale');  

ID=importdata(directory,'\n');
K=size(ID,1);   
Y=zeros(K,1); % labels

if size(ID,1)>1
Y=14;   % here n is 14 dimensition/features
else
disp('Empty File');        %no record in the data file
end

X=zeros(K,Y); % training set

for i=1:K
Rows=strsplit(deblank(char(ID(i))));
cols=size(Rows,2);
Y(i,1)=str2num(char(Rows(1)));
Rows=Rows(1,2:cols);
   for l=1:cols-1
        keyVal=strsplit(char(Rows(l)),':');
        X(i,str2num(char(keyVal(1))))=str2num(char(keyVal(2)));     %key and value 13:-1 for example
   end
   
end

lables=Y;
samples=X;
%disp(X);

end
