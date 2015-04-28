% RANSACH.M
% 16-720 Spring 2015 - *Stub* Provided
% Generates a panorama of two images
%
% Arguments: 
%     im1  - first image
%     im2  - second image
%
% Returns: 
%     im3  - generated panorama
%
% usage: im3 = generatePanorama(im1, im2)

function im3 = generatePanorama(im1, im2)
    ratio = 0.99;
    img1 = im2double(im1);
    %img1 = rgb2gray(img1);
    img2 = im2double(im2);
    %img2 = rgb2gray(img2);
    [l1, d1] = brief(img1);
    [l2, d2] = brief(img2);
    
    matches = briefMatch(d1, d2, ratio);
    
    nIter = 100;
    tol = 0.01;
    
    %figure(103);
    %plotMatches(im1, im2, matches);
    
    [~, ~, inliers] = ransacH(matches, l1, l2, nIter, tol);
    
    goodMatches = matches(find(inliers),:);
    p1 = l1(goodMatches(:,1),1:2);
    p2 = l2(goodMatches(:,2),1:2);
    p = [p1(:,2)';p1(:,1)';p2(:,2)';p2(:,1)'];
    
    figure(103);
    plotMatches(im1, im2, p);
    %pano4_2(im1,im2,p);
    
    
    
    %%%%%%%%%%%%%
    
    
    os2 = 1280;
    
    H2to1 = computeH_norm(p(1:2,:),p(3:4,:));
    
    topLeft = H2to1 * [1;1;1];
    topRight = H2to1 * [size(im2,2);1;1];
    bottomLeft = H2to1 * [1;size(im2,1);1];
    bottomRight = H2to1 * [size(im2,2);size(im2,1);1];
    
    topLeft = topLeft ./ topLeft(3);
    topRight = topRight ./ topRight(3);
    bottomLeft = bottomLeft ./ bottomLeft(3);
    bottomRight = bottomRight ./bottomRight(3);
    
    
    minX = min([1,topLeft(1),topRight(1),bottomLeft(1),bottomRight(1)]);
    maxX = max([size(im1,2),topLeft(1),topRight(1),bottomLeft(1),bottomRight(1)]);
    minY = min([1,topLeft(2),topRight(2),bottomLeft(2),bottomRight(2)]);
    maxY = max([size(im1,1),topLeft(2),topRight(2),bottomLeft(2),bottomRight(2)]);
    w = maxX - minX;
    h = maxY - minY;
    
    tx = -minX;
    ty = -minY;
    
    T = [1,0,tx;0,1,ty;0,0,1];
    
    % compute x scale
    s = os2 / (maxX - minX);
    new_size = ceil([h/w*os2,os2]);
    S = [s,0,0;0,s,0;0,0,1];
    
    M = S * T;
    
    warp_im1 = warpH(im1, M, new_size);
    warp_im2 = warpH(im2, M * H2to1, new_size);

    % compare each pixel in a to each pixel in b
    combImg = uint8(zeros([new_size,3]));
    a = combImg + warp_im1;
    b = combImg + warp_im2;

    mask = uint8(sum(a,3) <= 10);
    b(:,:,1) = b(:,:,1) .* mask;
    b(:,:,2) = b(:,:,2) .* mask;
    b(:,:,3) = b(:,:,3) .* mask;
    
 
    im3 = a + b;

end

