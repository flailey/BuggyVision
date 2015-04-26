% CREATEGAUSSIANPYRAMID.M
% Produces Gaussian Pyramid 
% 16-720 Spring 2015 - Provided Code
%   
% Arguments: 
%     im      - a grayscale image with range 0 to 1
%     sigma0  - the standard deviation of the blur at level 0
%     k       - the multiplicative factor of sigma at each level, where sigma=sigma_0 k^l
%     levels  - the levels of the pyramid where the blur at each level is sigma=sigma0 k^l
%               (e.g. levels = [?1,0,1,2,3,4])
%
% Returns: 
%     GaussianPyramid : A matrix of grayscale images of size (size(im),numel(levels))
%
% usage: [GaussianPyramid] = createGaussianPyramid(im, sigma0, k, levels)
%
% Modification History:
%      Arun Venkatraman (arunvenk@cs.cmu.edu) | February 9, 2015
%

function [GaussianPyramid] = createGaussianPyramid(im, sigma0, k, levels)
    % check if image is formatted correctly (value range, type)
    checkImInput(im);
    
    % allocate the required memory for the output
    GaussianPyramid = zeros([size(im),length(levels)]);

    for n = 1:length(levels)
        % Compute the Gaussian blur amount for this layer in the pyramid
        l = levels(n);
        sigma_ = sigma0 * k^l;

        % Create gaussian filter object
        h = fspecial('gaussian',floor(3*sigma_*2)+1,sigma_);

        % Apply the filter to the image and store output
        GaussianPyramid(:,:,n) = imfilter(im,h);
    end

end

% Check for various problems in the input image 
function checkImInput(im)
    if (max(im(:)) > 1) || (min(im(:)) < 0)    % Check if image has values in the correct range
        error('image contains values outside the range [0,1]. Try calling im2double() first')
    end 
    
    if (size(im,3) > 1)     % check if rgb image or something else weird
        error('image does not seem to be a grayscale image. Try calling rgb2gray() first.');
    end
    
    if (~isa(im, 'double'))
        error('image is not double typed. Try calling im2double() or double() first');
    end
end
