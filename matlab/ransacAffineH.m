function [ bestH, bestError, inliers ] = ransacAffineH( matches, locs1, locs2, nIter, tol )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
matchCount = size(matches,1);
    
    if ~exist('nIter', 'var') || isempty(nIter)
        nIter = 100;
    end

    if ~exist('tol', 'var') || isempty(tol)
        tol = 0.01;
    end

    
    bestH = 0;
    bestError = 0;
    bestCount = 0;
    inliers = 0;
    % loop nIter times
    for iter = 1 : nIter
        pick4 = randsample(matchCount,4);
        match4 = matches(pick4,:);
        p1 = locs1(match4(:,1),1:2);
        p2 = locs2(match4(:,2),1:2);

        hypH = findTransform([p1';p2']); % compute a hypothesis for H
        inCount = 0;
        totErr = 0;
        % test hypothesis for H
        hypInliers = zeros(matchCount,1);
        for i = 1:matchCount
            m = matches(i,:);
            m1 = locs1(m(:,1),1:2);
            m2 = locs2(m(:,2),1:2);

            m1p = hypH * [m1';1];
            m1p = m1p ./ m1p(3);
            m1p = m1p(1:2)';

            err = sqrt(sum((m1p - m2).^2));
            totErr = totErr + err;

            if(err < tol)
                % inlier
                inCount = inCount + 1;
                hypInliers(i) = 1;
            end
        end

        % is this the best one so far?
        if(inCount > bestCount)
            bestCount = inCount;
            bestError = totErr / matchCount;
            bestH = hypH;
            inliers = hypInliers;
        end
    end

end

