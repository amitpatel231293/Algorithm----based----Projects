
Add the YaleB dataset Cropped faces same as given folder with question: folder name"data"

This is an improvement on mplementation for fast L2 algorithm for face recognition on Extended YaleB dataset that is copy righted by Qinfeng (Javen) Shi, May 2011.
For L1 regulerization, feature_sign is used and which is copy righted just used for assignment perpose.

Performing tasks of assignment:
To change lambda value in any task file, Change the variable Lam
--------------
Task 1 : Run Task1_testFull_L1_YaleB_demo.m
Task 2 : Run Task2_testFull_L2_YaleB_fastcheckid_demo.m
Task 3 : Run Task3_FaceDetection.m
Bonus task1: Run Task4_FaceDetection_insupermarket.m

------------
Original read me:

Implementation for fast L2 algorithm for face recognition on Extended YaleB dataset
-----------------------------------------------------------------
Copyright Qinfeng (Javen) Shi, May 2011.
qinfeng.shi@ieee.org

This code package is provided for non-commercial academic research use.
Commercial use is strictly prohibited without the author's written
consent.

Please cite the following paper if you use this code package or part of it
in your publication:
[1] Qinfeng Shi, Anders Eriksson, Anton van den Hengel, Chunhua Shen, Is face recognition really a Compressive Sensing problem? In IEEE Computer Society Conference on Computer Vision and Pattern Recognition (CVPR 11), Colorado Springs, USA, June 21-23, 2011. 
http://users.cecs.anu.edu.au/~qshi/pub/face_cvpr11.pdf

-------------
Preliminaries
-------------

Code:
This distribution of codes implement the following:
1. fast L2 method in testFull_L2_YaleB_fastcheckid_demo.m.
2. L1 method in testFull_L1_YaleB_demo.m.
3. check person in checkperson_YaleB_demo.m.
4. display boxes used in AR disguised data (i.e. in Sec 7 and Fig 5 in [1]).

The faster L2 method code does not need any further package installed.
The L1 method code needs cvx (Matlab Software for Disciplined Convex Programming) installed.

Data:
1. download the cropped Extended YaleB from
http://vision.ucsd.edu/extyaleb/CroppedYaleBZip/CroppedYale.zip
2. put it in ./data/ and unzip it.

Warning: the checkperson_YaleB_demo.m assumes both the test set has the same number of faces per person for simplicity. If your test data violates this, you will need to modify the code accordingly.

----------
Quickstart
----------

L2
>> testFull_L2_YaleB_fastcheckid_demo

L1
>> testFull_L1_YaleB_demo.m

----------
Results
----------

----------------------------------
L2 for face recognition 
----------------------------------
 Read data ... 
----------------------------------
 Split data into 
 train and test sets ... 
1-th person
2-th person
3-th person
4-th person
5-th person
6-th person
7-th person
8-th person
9-th person
10-th person
11-th person
12-th person
13-th person
14-th person
15-th person
16-th person
17-th person
18-th person
19-th person
20-th person
21-th person
22-th person
23-th person
24-th person
25-th person
26-th person
27-th person
28-th person
29-th person
30-th person
31-th person
32-th person
33-th person
34-th person
35-th person
36-th person
37-th person
38-th person
----------------------------------
orthonlise faces Offline ...
----------------------------------
Testing ...
Face: 100 
Face: 200 
Face: 300 
Face: 400 
Face: 500 
Face: 600 
Face: 700 
Face: 800 
Face: 900 
Face: 1000 
Face: 1100 
----------------------------------

    Report 

Runtime(seconds) offline:24.1338,estimation:2.72633,checkID:0.469504
Recognition Rate:0.990926