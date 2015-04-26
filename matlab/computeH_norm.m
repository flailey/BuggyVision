% COMPUTEH_NORM.M
% 16-720 Spring 2015 - *Stub* Provided
% Computes the best fit homography matix in the least-squares sense.
% This version normalizes the input coordinates p1 and p2 prior to calling
% compute_H() to find the actual homography. The normalizaiton scales the
% points so that the average distance to the mean of the original points is
% sqrt(2).
%
% Arguments: 
%     p1    - 2xN matrix with (x,y)^T image coordinates for image 1
%             N is the number of points.
%     p2    - 2xN matrix with (x,y)^T image coordinates for image 2
%             Each point (column) in p2 corresponds with the respective
%             column in p1
% Returns: 
%     H2to1 - 3x3 homography matrix computed from p1 and p2. It is the best
%             fit given p1 and p2 in the least-squares sense.
%
% usage: [H2to1] = computeH_norm(p1, p2)


function [H2to1] = computeH_norm(p1, p2)
    % normalize p1 and p2
    
    [~,s] = size(p1); % p1 and p2 must be equal in size
    
    % translate centroid to origin
    p1Centroid = [0;0];
    p2Centroid = [0;0];
    for i = 1:s
        p1Centroid = p1Centroid + p1(:,i);
        p2Centroid = p2Centroid + p2(:,i);
    end
    p1Centroid = p1Centroid / s;
    p2Centroid = p2Centroid / s;
    
    % scale such that avg distance to origin is sqrt(2)
    p1TotalDistance = 0;
    p2TotalDistance = 0;
    for i = 1:s
        p1c = p1(:,i) - p1Centroid;
        p2c = p2(:,i) - p2Centroid;
        p1TotalDistance = p1TotalDistance + sqrt(p1c(1)^2 + p1c(2)^2);
        p2TotalDistance = p2TotalDistance + sqrt(p2c(1)^2 + p2c(2)^2);
    end
    p1Dist = (sqrt(2) * s) / p1TotalDistance;
    p2Dist = (sqrt(2) * s) / p2TotalDistance;
    
    N1 = [p1Dist, 0,      -p1Dist*p1Centroid(1); ...
          0,      p1Dist, -p1Dist*p1Centroid(2); ...
          0,      0,      1];
    N2 = [p2Dist, 0,      -p2Dist*p2Centroid(1); ...
          0,      p2Dist, -p2Dist*p2Centroid(2); ...
          0,      0,      1];
    p1_3 = [p1;ones(1,s)];
    p2_3 = [p2;ones(1,s)];
    
    p1_n = N1 * p1_3;
    p2_n = N2 * p2_3;
    
    % calculate H
    H2to1_n = computeH(p1_n(1:2,:), p2_n(1:2,:));
    
    % denormalize homography matrix
    H2to1 = N1 \ H2to1_n * N2;
    
end
