% COMPUTEH.M
% 16-720 Spring 2015 - *Stub* Provided
% Computes the best fit homography matix in the least-squares sense.
%
% Arguments: 
%     p1    - 2xN matrix with (x,y)^T image coordinates for image 1
%             N is the number of points.
%     p2    - 2xN matrix with (x,y)^T image coordinates for image 2
%             Each point (column) in p1 corresponds with the respective
%             column in p1
% Returns: 
%     H2to1 - 3x3 homography matrix computed from p1 and p2. It is the best
%             fit given p1 and p2 in the least-squares sense.
%
% usage: [H2to1] = computeH(p1, p2)


function [H2to1] = computeH(p1, p2)
    [~,n] = size(p1); % size of p1 must be equal to size of p2
    A = zeros(2*n,9);
    % construct matrix 'A' with a bunch of loops (inefficient)
    for p = 1:n
        x1 = p1(1,p);
        x2 = p2(1,p);
        y1 = p1(2,p);
        y2 = p2(2,p);
        A(2*p-1,:) = [-x2, -y2, -1,   0,   0,  0, x2*x1, y2*x1, x1];
        A(2*p,:) =   [0  ,   0,  0, -x2, -y2, -1, x2*y1, y2*y1, y1];
    end
    [~,~,V] = svd(A); % we could use svd(A' * A), but this gives the same results with less computation.
    % The ninth column is associated with the smallest eigenvector
    H2to1 = reshape(V(:,9),[3,3])';
end
