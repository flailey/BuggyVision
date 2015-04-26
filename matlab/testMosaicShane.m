vid = loadVideo(2);

fNum = 1350; % 1300

frame1 = read(vid,fNum);

mask = imread('../data/buggyMask1.png');
mask = imresize(mask, 0.1);
mask = im2bw(mask,0.5);

%figure(100);
%imagesc(frame);

wFrame1 = transformToFlat(frame1);


frame2 = read(vid,fNum + 2);
wFrame2 = transformToFlat(frame2);

frame1 = imresize(frame1, 0.1);
frame2 = imresize(frame2, 0.1);

%wFrame1 = imresize(wFrame1, 0.5);
%wFrame2 = imresize(wFrame2, 0.5);

figure(101);
I = rgb2gray(frame1);
%points = detectBRISKFeatures(I);
%corners = detectFASTFeatures(I);
%regions = detectMSERFeatures(I);
%points = detectSURFFeatures(I);
%points = detectHarrisFeatures(I);
points = detectMinEigenFeatures(I);
%[f1, vpts1, hogVisualization] = extractHOGFeatures(wFrame1, regions);
[f1, vpts1] = extractFeatures(I, points);
imshow(frame1); hold on;
plot(points.selectStrongest(1000));
%plot(corners.selectStrongest(40));
%plot(regions, 'showPixelList', true, 'showEllipses', false);
%plot(points.selectStrongest(10));
%plot(hogVisualization);



figure(102);
I2 = rgb2gray(frame2);
%points2 = detectBRISKFeatures(I2);
%points2 = detectHarrisFeatures(I);
points2 = detectMinEigenFeatures(I);
%corners2 = detectFASTFeatures(I2);
%regions2 = detectMSERFeatures(I2);
%points2 = detectSURFFeatures(I2);
%imshow(wFrame2); hold on;
%[f2, vpts2, hogVisualization] = extractHOGFeatures(wFrame2, regions2);
[f2, vpts2] = extractFeatures(I2, points2);
imshow(frame2); hold on;
plot(points2.selectStrongest(1000));
%plot(corners.selectStrongest(40));
%plot(points.selectStrongest(10));
%figure(101);
%imshow(wFrame1);
%plot(hogVisualization);


indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(:, 1));
matchedPoints2 = vpts2(indexPairs(:, 2));


figure(103); ax = axes;
showMatchedFeatures(frame1, frame2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

%figure(101);
%imshow(wFrame1);

%figure(102);
%imshow(wFrame2);


%figure(103);
%displayFeatures(wFrame1);
%figure(104);
%displayFeatures(wFrame2);



%pan = generatePanorama(wFrame2, wFrame1);
%pan = stitchImages(wFrame2, wFrame1);

%figure(104);
%imshow(pan);

