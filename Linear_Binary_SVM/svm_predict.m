function result_labels=svm_predict(testSamples, testLabels, model)

w = model.w;
b = model.b;

[m,n]=size(testLabels);
result_labels=zeros(m,1);
result_labels=sign(testSamples*w+b);  % lable=sign(wx+b)
accuracy=sum(result_labels==testLabels)/m;   % predicting accuracy

fprintf('the optimal accuracy is %f ( %d/%d )\n',accuracy,sum(result_labels==testLabels),m);  %output  

end
