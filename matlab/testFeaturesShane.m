%tests frames with feature extractors

vid = loadVideo(2);
figure(1);
F = createFilterBank();

fNum = 1110; % 1300
numFrames = 200;
for i = 1:numFrames
    frame = read(vid,fNum + i);
    
    frame = imresize(frame, 0.6);
    
    %frame = imsharpen(frame);
    
    I = rgb2gray(frame);
    %I = imadjust(I,stretchlim(I),[]);
    I = edge(I, 'canny', 0.01);
    %points = detectBRISKFeatures(I);
    %corners = detectFASTFeatures(I);
    %regions = detectMSERFeatures(I);
    %points = detectSURFFeatures(I);
    %points = detectHarrisFeatures(I);
    points = detectMinEigenFeatures(I);
    %[f1, vpts1, hogVisualization] = extractHOGFeatures(wFrame1, regions);
    [f1, vpts1] = extractFeatures(I, points);
    imshow(I); hold on;
    plot(points.selectStrongest(1000));
    %plot(corners.selectStrongest(40));
    %plot(regions, 'showPixelList', true, 'showEllipses', false);
    %plot(points.selectStrongest(10));
    %plot(hogVisualization);
    drawnow;
end
hold off;
