% CREATEDOGPYRAMID.M
% 16-720 Spring 2015 - *Stub* Provided
%   
% Arguments: 
%     GaussianPyramid - Matrix of size (height x width x num_levels)
%     levels          - Vector with num_levels elements
% Returns: 
%     DoGPyramid - A matrix representing the DoG pyramid. Should have
%                  dimensions (height x width x num_levels - 1)
%     DoGLevels  - A vector 
%
% usage: [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)


function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)
    % each level is D = GP(l) - GP(l-1)
    [w,h,d] = size(GaussianPyramid);
    DoGPyramid = zeros(w,h,d-1);
    for i = 2:d
        DoGPyramid(:,:,i-1) = GaussianPyramid(:,:,i) - GaussianPyramid(:,:,i-1);
    end
    [~,s] = size(levels);
    DoGLevels = levels(2:s);
end
