vid = loadVideo(2);

fNum = 1400; % 1300

frame1 = read(vid,fNum);

mask = imread('../data/buggyMask1.png');
mask = imresize(mask, 0.1);
mask = im2bw(mask,0.5);

%figure(100);
%imagesc(frame);

wFrame1 = transformToFlat(frame1);
imwrite(wFrame1,'flat1.png');

frame2 = read(vid,fNum + 2);
wFrame2 = transformToFlat(frame2);

wFrame1 = imresize(wFrame1, 0.3);
wFrame2 = imresize(wFrame2, 0.3);

%figure(101);
I = rgb2gray(wFrame1);
%points = detectBRISKFeatures(I);
%corners = detectFASTFeatures(I);
%regions = detectMSERFeatures(I);
points = detectSURFFeatures(I);
%[f1, vpts1, hogVisualization] = extractHOGFeatures(wFrame1, regions);
[f1, vpts1] = extractFeatures(I, points);
imshow(wFrame1); hold on;
plot(points.selectStrongest(40));
%plot(corners.selectStrongest(40));
%plot(regions, 'showPixelList', true, 'showEllipses', false);
%plot(points.selectStrongest(10));
%plot(hogVisualization);



figure(102);
I2 = rgb2gray(wFrame2);
%points = detectBRISKFeatures(I2);
%corners = detectFASTFeatures(I2);
%regions2 = detectMSERFeatures(I2);
points2 = detectSURFFeatures(I2);
%imshow(wFrame2); hold on;
%[f2, vpts2, hogVisualization] = extractHOGFeatures(wFrame2, regions2);
[f2, vpts2] = extractFeatures(I2, points2);
imshow(wFrame2); hold on;
plot(points2.selectStrongest(40));
%plot(corners.selectStrongest(40));
%plot(points.selectStrongest(10));
%figure(101);
%imshow(wFrame1);
%plot(hogVisualization);


indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(:, 1));
matchedPoints2 = vpts2(indexPairs(:, 2));


figure(103); ax = axes;
showMatchedFeatures(wFrame1, wFrame2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

figure(101);
imshow(wFrame1);

figure(102);
imshow(wFrame2);


%figure(103);
%displayFeatures(wFrame1);
%figure(104);
%displayFeatures(wFrame2);



%pan = generatePanorama(wFrame2, wFrame1);
%pan = stitchImages(wFrame2, wFrame1);

%figure(104);
%imshow(pan);

