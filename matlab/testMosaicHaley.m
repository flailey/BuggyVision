vid = loadVideo(2);
fNum = 1400; % 1300

% constants
resizeto = 0.3;
cropHeight = 150;
cropWindow = [1, cropHeight, 854, 480-cropHeight];


% load mask
mask = imread('../data/buggyMask1.png');
mask = imresize(mask, resizeto);
mask = im2bw(mask,0.5);

% load, mask, and transform frame 1
frame1 = read(vid,fNum);
frame1 = imcrop(frame1,cropWindow);
wFrame1 = transformToFlat(frame1);

%
%figure(100);
%imagesc(frame1);
%imagesc(rgb2gray(frame1));

% load, mask, and transform frame 2
frame2 = read(vid,fNum + 2);
frame2 = imcrop(frame2,cropWindow);
wFrame2 = transformToFlat(frame2);

% resize the transformed frames
wFrame1 = imresize(wFrame1, resizeto);
wFrame2 = imresize(wFrame2, resizeto);

% display the frames
figure(10);
imshow(wFrame1);
figure(11);
imshow(wFrame2);
