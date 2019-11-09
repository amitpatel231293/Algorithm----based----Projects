To run the program there should be an image named input.jpg in the same folder of code. Depending on image, parameters in each files should be changes according described below.

To run:

Directly run the file run.m(It does not need any external libraries like openCV or anything)

Note:
If parameters are not set according than, it can cause error. better to clean all variable before running on another image. Also, all output images will be saved in the same folder with different names.

Specification of parameter values in different files:

The human face/specified objects in image:

In smoothing.m:
here in advanced smoothing sharpness needed more for face edges for artistic image which can be achieved by quan=4

In Quantization.m:
need to put colours between 5-10 for cartonified effect due to having less color differences.so, no:7
Dark_index=1.4

In Edging.m:
edges are needed to be more as it small detailing of the faces with almost same colors, so thresold should be:0.02

For Scenory:

In smmothing.m:
here, we can make a more blurr, so quan=8.

In smoothing.m:
NoOfColors: 25 better to put 25-35 colors.
Dark_index=2

In edging.m:
edges are needed to be less as it disturbs the scenory backgrounds, so thresold should be:0.05.


