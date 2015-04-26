% COMPUTEPRINCIPALCURVATURE.M
% 16-720 Spring 2015 - *Stub* Provided
%   
% Arguments: 
%     DoGPyramid - Matrix of size (height x width x m)
% Returns: 
%     PrincipalCurvature - A matrix of size (height x width x m) where each
%                          element represents the curvature ratio for each
%                          corresponding point in the DoG pyramid.
%
% usage: PrincipalCurvature = computePrincipalCurvature(DoGPyramid))


function [PrincipalCurvature] = computePrincipalCurvature(DoGPyramid)
    % Compute the principal curvature, using methods described in paper
    %H = [xx,xy;yx,yy];
    PrincipalCurvature = zeros(size(DoGPyramid));
    [~,~,l] = size(DoGPyramid);
    for i = 1:l
        [Dx, Dy] = gradient(DoGPyramid(:,:,i));
        [Dxy, Dyy] = gradient(Dy);
        [Dxx, Dyx] = gradient(Dx);

        trace = Dxx + Dyy;
        det = Dxx .* Dyy + Dxy .* Dyx;
        PrincipalCurvature(:,:,i) = (trace .^ 2) ./ det;
    end
    
    
    
end
