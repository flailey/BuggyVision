function im3 = stitchImages(im1, im2)
    ratio = 0.9;
    img1 = im2double(im1);
    img1 = rgb2gray(img1);
    img2 = im2double(im2);
    img2 = rgb2gray(img2);
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
    
    % get the transform
    H = findTransform(p);
    
    %H = eye(3);
    
    new_size = [300,300];
    
    warp_im1 = affineH(im1, H, new_size);
    warp_im2 = affineH(im2, H, new_size);

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

