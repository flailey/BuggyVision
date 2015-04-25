vid = loadVideo(2);

frame = read(vid,3540);

figure(100);
imagesc(frame);

wFrame = transformToFlat(frame);

figure(101);
imshow(wFrame);