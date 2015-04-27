vid = loadVideo(3);
fNum = 50;

% constants
resizeto = .6;
tilt = -1 * degtorad(0.05) / resizeto;

% load, mask, and transform frame 1
frame1 = read(vid,fNum);
frame1 = imresize(frame1, resizeto);
wFrame1 = transformToFlatMobot(frame1, tilt, 0);

figure(100);
imagesc(frame1);

% load, mask, and transform frame 2
frame2 = read(vid,fNum + 5);
frame2 = imresize(frame2, resizeto);
wFrame2 = transformToFlatMobot(frame2, tilt, 0);

Im1 = wFrame1;
Im2 = wFrame2;

%%
figure(101);
I1 = rgb2gray(Im1);
points = detectBRISKFeatures(I1);
[f1, vpts1] = extractFeatures(I1, points);
imshow(Im1); hold on;
plot(points.selectStrongest(1000));

figure(102);
I2 = rgb2gray(Im2);
points2 = detectBRISKFeatures(I2);
[f2, vpts2] = extractFeatures(I2, points2);
imshow(Im2); hold on;
plot(points2.selectStrongest(1000));

%%
indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(:, 1));
matchedPoints2 = vpts2(indexPairs(:, 2));

%%
figure(103);
showMatchedFeatures(Im1,Im2,matchedPoints1,matchedPoints2,'montage');
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');
