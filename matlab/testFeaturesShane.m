%tests frames with feature extractors

vid = VideoReader('../data/large/mobot1.mov');

%F = createFilterBank();
scale = 0.5;
fNum = 1; % 1300
numFrames = 200;
% constants
tilt = -1 * degtorad(0.05) / scale;




%mask = imread('../data/IcarusMask1.png');
%mask = double(im2bw(mask,0.5));

for i = 1:10:numFrames
    
    frame1 = read(vid, fNum + i);
    
    frame1 = imresize(frame1, scale);
    
    % load, mask, and transform frame 1
    frame1 = transformToFlatMobot(frame1,tilt,0);
    
    I1 = rgb2gray(frame1);
    
    %I = imadjust(I,stretchlim(I),[]);
    %I = edge(I, 'canny', 0.01);
    points = detectBRISKFeatures(I1);
    %corners = detectFASTFeatures(I1);
    %regions = detectMSERFeatures(frame1);
    %points = detectSURFFeatures(I);
    %points = detectHarrisFeatures(I);
    %points = detectMinEigenFeatures(I);
    %[f1, vpts1, hogVisualization] = extractHOGFeatures(wFrame1, regions);
    
    [f1, vpts1] = extractFeatures(I1, points);
    %f2 = f1;
    %vpts2 = vpts1;
    %imshow(I1); hold on;
    %plot(corners.selectStrongest(100));
    
    %plot(corners.selectStrongest(40));
    %plot(regions, 'showPixelList', true, 'showEllipses', false);
    %plot(points.selectStrongest(10));
    %plot(hogVisualization);
    
    if(i > 1)
    indexPairs = matchFeatures(f1, f2,'MatchThreshold',50);
    matchedPoints1 = vpts1(indexPairs(:, 1));
    matchedPoints2 = vpts2(indexPairs(:, 2));

    % display the matched points from frames i and i-1
    %figure(1);
    %ax = axes;
    %showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2,'Parent',ax);
    %title(ax, 'Candidate point matches');
    %legend(ax, 'Matched points 1','Matched points 2');
    
    
    % generate a combined image from the 2 most recent images
    matches = [1:matchedPoints1.Count;1:matchedPoints1.Count]';
    locs1 = matchedPoints1.Location;
    locs2 = matchedPoints2.Location;
    nIter = 100;
    tol = 5;
    %[bestH, bestError, inliers] = ransacH(matches, locs2, locs1, nIter, tol);
    %p = generatePanorama(I1,I2);
    %pan = stitchImages(I2, I1);
    %imshow(pan);
    %wI1 = warpH(frame1,double(bestH),size(I1),0);
    [bestH, bestError, inliers] = ransacAffineH(matches, locs1, locs2, nIter, tol);
    %findTransform([locs1';locs2']);
    
    wI1 = affineH(frame1,double(bestH),size(I1),0);
    
    % visualize ransac'd points
    indicies = find(inliers);
    
    
    p = wI1 .* 0.5 + frame2 .*0.5;
    %figure(1);
    %ax = axes;
    %showMatchedFeatures(wI1, I2, matchedPoints1, matchedPoints2,'Parent',ax);
    %figure(2);
    
    ax = axes;
    showMatchedFeatures(wI1, I2, matchedPoints1(indicies), matchedPoints2(indicies),'Parent',ax);
    %imshow(p);
    drawnow;
    
    %k = waitforbuttonpress;
    end
    f2 = f1;
    vpts2 = vpts1;
    I2 = I1;
    frame2 = frame1;
    
end
hold off;
