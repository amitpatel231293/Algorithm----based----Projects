function [model2]=main_test()
% Support Vector Machines

clear ; close all; clc

%australian_scale contains 690 rows so,
% train: 1:511
% test: 514:690

[australian_scale_label, australian_scale_inst]=read_data();
[N,D]=size(australian_scale_inst);


% Determine the train and test index
training_Index = zeros(N,1); training_Index(1:511) = 1;
testing_Index = zeros(N,1); testing_Index(514:N) = 1;

training_Data = australian_scale_inst(training_Index==1,:);
training_Label = australian_scale_label(training_Index==1,:);

testing_Data = australian_scale_inst(testing_Index==1,:);
testing_Label = australian_scale_label(testing_Index==1,:);  

%Training Linear SVM

fprintf('\nTraining...\n')

% can try C = 100 for different bountry line
C = 1;
eps=1e-06;  %epsilon is for dual problem

model = svmdual_training(training_Data, training_Label, C,eps);%get w and b %
%model = svmprimal_training(training_Data, training_Label, C,eps);%get w and b 

predictLabels=svm_predict(testing_Data,testing_Label,model);

% Reduce the dimension from 13D to 2D
distanceMatrix = pdist(australian_scale_inst,'euclidean');   
Cordinate2 = mdscale(distanceMatrix,2);          

% Plot the whole data set
x = Cordinate2(:,1);   
y = Cordinate2(:,2); 
model2.x=x;
model2.y=y;
model2.training_label=training_Label;
pos0 = find(training_Label == 1);                       % trainning data
neg0 = find(training_Label == -1);
plot(x(pos0), y(pos0), 'b.','LineWidth', 1, 'MarkerSize', 7)   %ground truth postive samples
hold on;
plot(x(neg0), y(neg0), 'y.', 'LineWidth', 1, 'MarkerSize', 7) %ground truth negative samples
hold on;
disp('press enter to see the testing result.')
pause;

% Plotting the result...
pos_one = find(testing_Label == 1)+size(training_Label,1);               
neg_one = find(testing_Label == -1)+size(training_Label,1);

pos2=find(predictLabels==1)+size(training_Label,1);     % predicting labels for testing data
neg2=find(predictLabels==-1)+size(training_Label,1);

% Plot Examples
plot(x(pos_one), y(pos_one), 'k+','LineWidth', 1, 'MarkerSize', 8) 
hold on;

plot(x(pos2), y(pos2), 'ko','LineWidth', 1, 'MarkerSize', 8)  
hold on;

plot(x(neg_one), y(neg_one), 'r+', 'LineWidth', 1, 'MarkerSize', 8) 
hold on;

plot(x(neg2), y(neg2), 'ro', 'LineWidth', 1, 'MarkerSize', 8) 
hold on;

end