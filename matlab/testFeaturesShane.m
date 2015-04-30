%tests frames with feature extractors
close
vid = VideoReader('../data/large/mobot1.mov');
myVideo = VideoWriter('../outputs/mappingVideo.avi');
uncompressedVideo = VideoWriter('myfile.avi', 'Uncompressed AVI');

myVideo.FrameRate = 5;  % Default 30
myVideo.Quality = 75;    % Default 75

open(myVideo);

%F = createFilterBank();
scale = 0.1;
fNum = 1; % 1300
numFrames = vid.NumberOfFrames;
%numFrames = 200;
% constants
tilt = -1 * degtorad(0.05) / scale;

bigScale = 0.2;
% known size
bigFlatSize = [2160 * bigScale, 3480 * bigScale, 3];
flatWidth = 3480 * bigScale;
flatHeight = 2160 * bigScale;

%mask = imread('../data/IcarusMask1.png');
%mask = double(im2bw(mask,0.5));

%m = ones(size(bigFrame1));
%wMask = transformToFlatMobot(m,tilt * bigScale,0);


if(not(exist('mov','var')))
    vidWidth = vid.Width;
    vidHeight = vid.Height;
    mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'));

    %%% preload the video %%%

    k = 1;
    for i = 1:10:numFrames
        mov(k).cdata = read(vid, fNum + i); %readFrame(xyloObj);
        k = k+1;
        fprintf('%d\n',k);
    end
end
hdiv = .75;
vdiv = .5;
%map = uint8(zeros(flatHeight * 10, flatWidth * 2, 3));
map = double(zeros(flatHeight * 10, flatWidth * 2, 3));
mapH = [1,0,flatWidth * 0.5;
    0,1,flatHeight*8.75;
    0,0,1];
vframes = struct('vframes',zeros(1024,768,3,'uint8'));
h = figure('Position', [100, 100, 800, 800]);
whitebg('black')

for i = 1:size(mov,2);
    
    %frame1 = read(vid, fNum + i);
    %tic;
    bigframe1 = mov(i).cdata; %read(vid, fNum + i);
    
    
    %frame1 = readFrame(vid);
    %toc
    frame1 = imresize(bigframe1, scale);
    
    bigframe1 = imresize(bigframe1, bigScale);
    
    m = ones(size(bigframe1));
    wMask = transformToFlatMobot(m,tilt * scale / bigScale,0);

    
    % load, mask, and transform frame 1
    frame1 = transformToFlatMobot(frame1,tilt,0);
    
    I1 = rgb2gray(frame1);
    
    %I = imadjust(I,stretchlim(I),[]);
    %I = edge(I, 'canny', 0.01);
    %points = detectBRISKFeatures(I1);
    %corners = detectFASTFeatures(I1);
    %regions = detectMSERFeatures(frame1);
    %points = detectSURFFeatures(I1);
    %points = detectHarrisFeatures(I1);
    points = detectMinEigenFeatures(I1);
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
    bigFlatFrame1 = transformToFlatMobot(bigframe1,tilt * scale / bigScale,0);
    
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
    matches = [1:matchedPoints1.Count; 1:matchedPoints1.Count]';
    locs1 = matchedPoints1.Location;
    locs2 = matchedPoints2.Location;
    nIter = 100;
    tol = 10 * scale;
    %[bestH, bestError, inliers] = ransacH(matches, locs2, locs1, nIter, tol);
    %p = generatePanorama(I1,I2);
    %pan = stitchImages(I2, I1);
    %imshow(pan);
    %wI1 = warpH(frame1,double(bestH),size(I1),0);
    [bestH, bestError, inliers] = ransacAffineH(matches, locs1, locs2, nIter, tol);
    %findTransform([locs1';locs2']);
    bestH(1:2,3) = bestH(1:2,3).*(1/scale) * bigScale;
    %bestH(3,:) = [0,0,1];
    
    wI1 = affineH(bigFlatFrame1, double(bestH), size(bigFlatFrame1),0);
    
    % visualize ransac'd points
    indicies = find(inliers);
    
    %p = wI1 .* 0.5 + frame2 .*0.5;
    %figure(1);
    %ax = axes;
    %showMatchedFeatures(wI1, I2, matchedPoints1, matchedPoints2,'Parent',ax);
    %figure(2);
    
    %ax = axes;
    %subplot(2,2,1);
    subplot('Position',[0 vdiv hdiv vdiv]);
    imshow(mov(i).cdata);
    
    
    fprintf('gogogo\n');
    %imshow(transformToFlatMobot(bigframe1,tilt * scale,0));
    mp1 = matchedPoints1(indicies);
    mp1.Location = mp1.Location .* (1/scale) * bigScale;
    mp2 = matchedPoints2(indicies);
    mp2.Location = mp2.Location .* (1/scale) * bigScale;
    %bigWI1 = affineH(bigFlatFrame1, double(bestH), size(bigFlatFrame1),0);
    %subplot(2,2,3);
    subplot('Position',[0 0 hdiv (1-vdiv)]);
    %ax = axes;
    showMatchedFeatures(wI1, bigFlatFrame2, mp1, mp2);
    %imshow(p);
    
    %%% pad image to match size of map %%%
    
    mapH = double(mapH * bestH);
    wmap = affineH(bigFlatFrame1, mapH, size(map),0);
    
    %map = max(map,wmap);
    mask = affineH(wMask, mapH, size(map), 0);
    
    
    %mask = mask .* repmat(sum(wmap,3) > 150,[1,1,3]);
    %mask = mask .* repmat(sum(wmap,3) < (sum(map,3) + 100),[1,1,3]);
    
    
    %mask = double(sum(wmap,3) <= 50);
    %f = fspecial('gaussian', size(mask), 5.0); 
    %mask = imfilter(mask, f);
    %imagesc(mask);
    %mask = uint8(mask > 0.1);
    
    map = map .* (-mask + 1);
    
    % don't replace pixels if new value < 100 (r, g, or b) so we get rid of
    % shadow
    
    %imagesc(-mask + 1);
    %map(:,:,2) = map(:,:,2) .* (-mask + 1);
    %map(:,:,3) = map(:,:,3) .* (-mask + 1);
    
    map = map + double(wmap);
    %subplot(2,2,[2,4]);
    subplot('Position',[hdiv 0 (1-hdiv) 1]);
    imshow(uint8(map));
    
    
    drawnow;
    
    %vframes(i).vframes = getimage(h);
    %subplot(1,1,1);
    f = getframe(h);
    writeVideo(myVideo, f.cdata);
    
    %k = waitforbuttonpress;
    end
    f2 = f1;
    vpts2 = vpts1;
    I2 = I1;
    frame2 = frame1;
    bigframe2 = bigframe1;
    bigFlatFrame2 = bigFlatFrame1;
    
end
close(myVideo);
hold off;
