vid = loadVideo(1);

fNum = 1300;

frame1 = read(vid,fNum);

mask = imread('../data/buggyMask1.png');
mask = imresize(mask, 0.1);
mask = im2bw(mask,0.5);

%figure(100);
%imagesc(frame);

wFrame1 = transformToFlat(frame1);
imwrite(wFrame1,'flat1.png');

frame2 = read(vid,fNum + 10);
wFrame2 = transformToFlat(frame2);

wFrame1 = imresize(wFrame1, 0.1);
wFrame2 = imresize(wFrame2, 0.1);

%figure(101);
%imshow(wFrame1);

%figure(102);
%imshow(wFrame2);


%figure(103);
%displayFeatures(wFrame1);
%figure(104);
%displayFeatures(wFrame2);



%pan = generatePanorama(wFrame2, wFrame1);
pan = stitchImages(wFrame2, wFrame1);

figure(104);
imshow(pan);

