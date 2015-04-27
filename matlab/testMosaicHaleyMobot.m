vid = loadVideo(3);
fNum = 200;

% constants
resizeto = 0.1;

% load, mask, and transform frame 1
frame1 = read(vid,fNum);
wFrame1 = transformToFlatMobot(frame1);

%figure(100);
%imagesc(frame1);

% load, mask, and transform frame 2
frame2 = read(vid,fNum + 2);
wFrame2 = transformToFlatMobot(frame2);

Im1 = wFrame1;
Im2 = wFrame2;

% display the frames
figure(10);
imagesc(Im1);
figure(11);
imagesc(Im2);

