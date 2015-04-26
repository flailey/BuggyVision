% GETLOCALEXTREMA.M
% 16-720 Spring 2015 - *Stub* Provided
%   
% Arguments: 
%     im          - a grayscale image with range 0 to 1
%     sigma0      - the standard deviation of the blur at level 0
%     k           - the multiplicative factor of sigma at each level, where sigma=sigma_0 k^l
%     levels      - the levels of the pyramid where the blur at each level is sigma=sigma0 k^l
%                   (e.g. levels = [?1,0,1,2,3,4])
%     th_contrast - scalar threshold for DoG image
%     th_r        - scalar threshold for principal curvature
% Returns: 
%     locs - N-by-3 matrix where N is the number of local extrema found and
%            each row contains the (x,y) position and the corresponding
%            DoGLevel number. 
%     GaussianPyramid : A matrix of grayscale images of size (size(im),numel(levels))
%
% usage: [locs, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r)

function [locs, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r)
    GaussianPyramid = createGaussianPyramid(im, sigma0, k, levels);
    [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels);
    PrincipalCurvature = computePrincipalCurvature(DoGPyramid);
    locs = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, ...
        th_contrast, th_r);
end