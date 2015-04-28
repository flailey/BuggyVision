%tests frames with feature extractors

vid = VideoReader('../data/large/Icarus.mp4');
figure(1);
%F = createFilterBank();
scale = 0.5;
fNum = 2250; % 1300
numFrames = 200;

%mask = imread('../data/IcarusMask1.png');
%mask = double(im2bw(mask,0.5));

for i = 1:1:numFrames
    
    frame1 = read(vid, fNum + i);
    cropHeight = 150;
    cropWindow = [1, cropHeight, size(frame1,2), size(frame1,1)-cropHeight];    
    
    frame1 = imcrop(frame1,cropWindow);
    I1 = rgb2gray(frame1);
    %I2 = I1 .* mask;
    
    I1 = imresize(I1, scale);


    %frame2 = read(vid,fNum + i);
   
    
    %frame2 = imresize(frame2, scale);
    
    %frame = imsharpen(frame);
    
    %I2 = rgb2gray(frame2);
    
    %CI = conv2(I1,I2);
    %I = imadjust(I,stretchlim(I),[]);
    %I = edge(I, 'canny', 0.01);
    %points = detectBRISKFeatures(I1,'MinContrast',0.2,'NumOctaves',4);
    corners = detectFASTFeatures(I1);
    %regions = detectMSERFeatures(frame1);
    %points = detectSURFFeatures(I);
    %points = detectHarrisFeatures(I);
    %points = detectMinEigenFeatures(I);
    %[f1, vpts1, hogVisualization] = extractHOGFeatures(wFrame1, regions);
    
    [f1, vpts1] = extractFeatures(I1, corners);
    %f2 = f1;
    %vpts2 = vpts1;
    imshow(I1); hold on;
    plot(corners.selectStrongest(100));
    
    %plot(corners.selectStrongest(40));
    %plot(regions, 'showPixelList', true, 'showEllipses', false);
    %plot(points.selectStrongest(10));
    %plot(hogVisualization);
    
    if(i > 1)
    indexPairs = matchFeatures(f1, f2,'MatchThreshold',50);
    matchedPoints1 = vpts1(indexPairs(:, 1));
    matchedPoints2 = vpts2(indexPairs(:, 2));

    %figure(103); 
    %ax = axes;
    %showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2,'Parent',ax);
    %title(ax, 'Candidate point matches');
    %legend(ax, 'Matched points 1','Matched points 2');
    
    drawnow;
    %k = waitforbuttonpress;
    end
    f2 = f1;
    vpts2 = vpts1;
    I2 = I1;
    
end
hold off;
