function [model] = svmprimal_training(X, Y, C,e)
%   [model] = SVMTRAIN(X, Y, C, epsilon) trains an SVM classifier based on primal problem and returns trained model.
%   X is the matrix of training examples. Each row is a training example, and the jth column holds the jth feature.  
%   Y is a column matrix containing 1 for positive examples and -1 for negative examples.  
%   C is the standard SVM regularization parameter. 

% Data parameters
m = size(X, 1);   % rows of X
n = size(X, 2);   % cols of Y

% Map 0 to -1

% Variables
b = 0;
oneVec=ones(1,m);  %tmperal varibale for optimization

addpath('./cvx/');     %add cvx path

% Primal problem
% Get alphas.

disp('cvx begin...')
cvx_begin quiet
variable w(n,1); variable sigmai(m,1); variable b;   %optimization varibales
minimize(0.5*w'*w+C*oneVec*sigmai)         %objective function
subject to
    Y.*(X*w+b)>=oneVec'-sigmai;            %conditions
	sigmai>=0;
cvx_end
disp('cvx end...')

%show the result
disp('w:');
disp(w);
disp('b:');
disp(b);
% Save the model
model.b=b;
model.w=w;

end
