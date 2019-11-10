function visualizeBoundaryLinear(model2, model)
%VISUALIZEBOUNDARYLINEAR plots a linear decision boundary learned by the
%SVM
%   VISUALIZEBOUNDARYLINEAR(X, y, model) plots a linear decision boundary 
%   learned by the SVM and overlays the data on it

w = model.w;
b = model.b;

xp = linspace(min(w(:,1)), max(w(:,1)), 100);
yp = (w(1)*xp + b)/w(2);
plotingData(model2);
hold on
plot(xp, yp); 
hold off


end
