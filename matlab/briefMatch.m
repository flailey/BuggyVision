% BRIEFMATCH.M
% 16-720 Spring 2015 - *Stub* Provided
%   
% Arguments: 
%     desc1, desc2 - m-by-nbits, matrix of stacked BRIEF descriptors. 
%                    m is the number of valid descriptors. 
%                    desc1 is from the first image, desc2 is from the second
%     ratio        - Ratio value for the ratio test to suppress bad matches
% Returns: 
%     matches - p-by-2 matrix, where the first column are indices into desc1 
%               and the second column are indices into desc2.
% usage: [matches] = briefMatch(desc1, desc2, ratio)

function [matches] = briefMatch(desc1, desc2, ratio)
    [n,~] = size(desc1);
    [m,~] = size(desc2);
    D = pdist2(desc1, desc2, 'hamming');
    % D is nxm matrix of distances from desc1 to desc2
    
    matches = [];
    j = 1;
    for i = 1:n
        % find the best match for this row
        [bestMatch, index] = min(D(i,:));
        [secondMatch, ~] = min([D(i,1:index-1),D(i,index+1:end)]);
        if(bestMatch/secondMatch < ratio)
            matches(j,1) = i;
            matches(j,2) = index;
            j = j + 1;
        end
    end
    
    %compare = sort(D,2);
    %ratios = compare(:,1) ./ compare(:,2);
    %ratios = [ratios,ratios];
 
 
    %[~, matches] = min(D');
    
    
    %matches = [(1:n)',matches'];
    
    %matches = matches .* (ratios > ratio);
    %matches(matches==0) = 1;
    %matches = matches(matches~=0);
end