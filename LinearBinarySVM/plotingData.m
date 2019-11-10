function plotData(model2)
%PLOTDATA Plots the data points X and y into a new figure 
%   PLOTDATA(x,y) plots the data points with + for the positive examples
%   and o for the negative examples. X is assumed to be a Mx2 matrix.

% Create New Figure
figure;

x=model2.x;
y=model2.y;
training_label=model2.training_label;

pos0 = find(training_label == 1);                       % trainning data
neg0 = find(training_label == -1);
plot(x(pos0), y(pos0), 'b.','LineWidth', 1, 'MarkerSize', 7)   %ground truth postive samples
hold on;
plot(x(neg0), y(neg0), 'y.', 'LineWidth', 1, 'MarkerSize', 7) %ground truth negative samples




hold off;

end