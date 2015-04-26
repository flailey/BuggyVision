% COMPUTEBRIEF.M
% 16-720 Spring 2015 - *Stub* Provided
%   
% Arguments: 
%     im                 - a grayscale image with range 0 to 1
%     locs               - keypoints from the DoG detector
%     levels             - Gaussian scale levels from Section 1
%     compareX, compareY - Linear indices into the image patch (nbits x 1)
% Returns: 
%     locs - m-by-3 matrix, where the first two columns are the image
%            coordinates of keypoints and the third column is the pyramid
%            level of the keypoints
%     desc - m-by-nbits, matrix of stacked BRIEF descriptors. 
%            m is the number of valid descriptors
% usage: [locs,desc] = computeBrief(im, locs, levels, compareX, compareY)

function [locs,desc] = computeBrief(im, locs, levels, compareX, compareY)
    sigma0 = 1;
    k = sqrt(2);
    GaussianPyramid = createGaussianPyramid(im, sigma0, k, levels);
    [DoGPyramid, ~] = createDoGPyramid(GaussianPyramid, levels);
    
    % remove locs that are near the edge
    [numLocs,~] = size(locs);
    [nbits,~] = size(compareX);
    [w,h] = size(im);
    newLocs = [0,0,0];
    n = 1;
    for i = 1:numLocs
        if(locs(i,1) > 4 && locs(i,1) < w-4 && locs(i,2) > 4 && locs(i,2) < h-4)
            newLocs(n,:) = locs(i,:);
            n = n + 1;
        end
    end
    locs = newLocs;
    
    % remove locs that are in the masked area
    mask = imread('../data/buggyMask1.png');
    mask = imresize(mask, 0.1);
    mask = im2bw(mask,0.5);
    newLocs = [0,0,0];
    [numLocs,~] = size(locs);
    n = 1;
    for i = 1:numLocs
        if((mask(locs(i,1),locs(i,2)) == 0))
            newLocs(n,:) = locs(i,:);
            n = n + 1;
        end
    end
    locs = newLocs;
    
    
    [numLocs,~] = size(locs);
    numel(locs)
    
    % compute BRIEF descriptors for interest points
    desc = zeros(numLocs, nbits);
    for i = 1:numLocs
        % get the patch for this interest point
        px = locs(i,1);
        py = locs(i,2);
        patch = DoGPyramid(px-4:px+4,py-4:py+4,locs(i,3));
        patch = reshape(patch, [81,1]);
        % compute the descriptor for this interest point
        for j = 1:nbits
            desc(i,j) = patch(compareX(j)) < patch(compareY(j));
        end
    end
    
end