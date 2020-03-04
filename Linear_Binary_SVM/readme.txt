Separate file running for getting alphas, w and b values on data Australian_scale.txt:
1) Run Read_data.m by command [Y,X]=read_data() || Y is label and X is data matrix.
2) Run svmprimal_training for getting primal Ws and b by [model]=svmprimal_training(X, Y, 1, 0)
wgere, C=1 as constant to maximize the margin and 0 is epsilon as it does not male difference. This will make a model where we can find alphas.
3) Run main_test.m to find the accuracy which is driven by the svm_predict function. To run command main_test() also, can [model2]=main_test()
4) To use plotingData.m run plotingData(model2) where model2 has x and y Here, x is in the 2D data from multidimensional data.
5) Lastly to see boundary, we can run visualizeBountryLinear.m, which gives the optimal hyperplane, but program is not supporting to the dimensions.
Or directly running:
Run 'main_test.m' to check the experiment (based on Australian_scale data from Libsvm) Which gives my code accuracy.

If CVX folder is not in the same folder then need to download CVX library from the website http://cvxr.com/cvx/download/ according to the Operating system