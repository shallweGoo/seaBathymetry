org_pic = imread("F:\workSpace\matlabWork\dispersion\selectPic\afterPer\˫����ڶ���任��\�任��ͼƬ2\uasDemo_1603582140167.jpg");
pi1 = org_pic(:,200);
res = gaussfilter(org_pic,100);
pi2 = res(:,200);
figure(1);plot((1:size(pi1,1)),pi1,'r',(1:size(pi1,1)),pi2,'black');
figure(2);imshow(res);
    