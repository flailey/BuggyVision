function [filterResponses] = extractFilterResponses(I, filterBank)
% 16720 CV Spring 2015 - Partially Provided Code
% Inputs: 
%   I:                  a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W*H x N*3 size matrix of filter responses

% NOTE: THIS IS IMPORTANT SINCE IMAGES DEFAULT IMPORT AT UINT8
doubleI = double(I);

% STEP 1: Call to RGB2Lab. See `help RGB2Lab' provided in the folder
labI = RGB2Lab(doubleI);

% STEP 2: Compute the number of pixels in each channel (not for all
%           channels combined). Hint: Width x Height
[w, h, n] = size(labI);
%pixelCount = w * h;

% STEP 3: Initialize output filter responses
filterResponses = zeros(w, h, 3*n);

%for each filter and channel, apply the filter, and vectorize
for filterI = 0:length(filterBank)-1
    % extract filter from the bank
    filter = filterBank{filterI+1};

    for channel = 1:3
        filterResponses(:,:,filterI*3+channel) = imfilter(labI(:,:,channel), filter, 'replicate');
        %filterResponses(:,:,filterI*3+2) = imfilter(A, filter);
        %filterResponses(:,:,filterI*3+3) = imfilter(B, filter);
    end
end

