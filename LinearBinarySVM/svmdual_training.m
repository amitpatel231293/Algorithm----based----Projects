function [model] = svmdual_training(X, Y, C, epsilon)
%   [model] = unisvamtrain(X, Y, C, epsilon) trains an SVM classifier and returns trained model based on sloving the dual problem.
%   X is the matrix of training examples. Each row is a training example, and the jth column holds the jth feature.  
%   Y is a column matrix containing 1 for positive examples and -1 for negative examples.  
%   C is the standard SVM regularization parameter. 

% Data parameters
[m,n] = size(X);   % rows and cols of X

% Variables
alphas = zeros(m, 1);
b = 0;
oneVec=ones(m,1);    % tmp unit vector for optimization
addpath('./cvx/')   


% Get alphas by cvx
disp('cvx begin...')
cvx_begin quiet
variable alphas(m,1);
maximize(alphas'*oneVec-0.5*(alphas.*Y)'*(X*X')*(alphas.*Y));
subject to 
0<=alphas<=C;
alphas'*Y==0;
cvx_end
disp('cvx end...')

% Save the model（calculate w and b)
epsilon=1e-6;
%epsilon=0;
idx = alphas > epsilon;
model.X= X(idx,:);
model.y= Y(idx);
model.alphas= alphas(idx);
model.w = ((alphas.*Y)'*X)';

% calculate b
num=size(model.alphas);
cnt=0;
for i=1:num
if(model.alphas(i)<C-epsilon)
b=b+1.0/model.y(i)-model.X(i,:)*model.w;
cnt=cnt+1;
end
end
b=b/cnt;
model.b= b;

disp(sprintf('Dual w:'))
disp(model.w)
disp(sprintf('Dual b'));
disp(model.b);
end
