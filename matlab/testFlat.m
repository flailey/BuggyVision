vid = loadVideo(1);

frame = read(vid,1);

wFrame = transformToFlat(frame);

imshow(wFrame);