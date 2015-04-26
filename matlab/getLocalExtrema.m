% DOGDETECTOR.M
% 16-720 Spring 2015 - *Stub* Provided
%   
% Arguments: 
%     DoGPyramid         - Matrix of size (height x width x m)
%     DoGLevels          - Vector with m elements
%     PrincipalCurvature - Matrix of size (height x width x m)
%     th_contrast        - scalar threshold for DoG image
%     th_r               - scalar threshold for principal curvature
% Returns: 
%     locs - N-by-3 matrix where N is the number of local extrema found and
%            each row contains the (x,y) position and the corresponding
%            DoGLevel number. 
%
% usage: locs = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, th_contrast, th_r)

function locs = getLocalExtrema(DoGPyramid, DoGLevels, ... 
                                PrincipalCurvature, th_contrast, th_r)
    
    locNum = 1;
    [w,h,levs] = size(DoGPyramid);
    % find local extrema
    for l = 1:(levs)
        for x = 2:(w-1)
            for y = 2:(h-1)
                if(DoGPyramid(x,y,l) < th_contrast) 
                    continue
                end
                if(PrincipalCurvature(x,y,l) > th_r)
                    continue
                end
                % do this for every valid pixel in every valid level
                if(l == 1)
                    e = [DoGPyramid(x,y,l),DoGPyramid(x+1,y,l), ...
                            DoGPyramid(x+1,y+1,l),DoGPyramid(x+1,y-1,l), ...
                            DoGPyramid(x,y+1,l),DoGPyramid(x,y-1,l), ...
                            DoGPyramid(x-1,y,l),DoGPyramid(x-1,y+1,l), ...
                            DoGPyramid(x-1,y-1,l),DoGPyramid(x,y,l+1)];
                else if(l == levs)
                        e = [DoGPyramid(x,y,l),DoGPyramid(x+1,y,l), ...
                            DoGPyramid(x+1,y+1,l),DoGPyramid(x+1,y-1,l), ...
                            DoGPyramid(x,y+1,l),DoGPyramid(x,y-1,l), ...
                            DoGPyramid(x-1,y,l),DoGPyramid(x-1,y+1,l), ...
                            DoGPyramid(x-1,y-1,l),DoGPyramid(x,y,l-1)];
                    else
                        e = [DoGPyramid(x,y,l),DoGPyramid(x+1,y,l), ...
                            DoGPyramid(x+1,y+1,l),DoGPyramid(x+1,y-1,l), ...
                            DoGPyramid(x,y+1,l),DoGPyramid(x,y-1,l), ...
                            DoGPyramid(x-1,y,l),DoGPyramid(x-1,y+1,l), ...
                            DoGPyramid(x-1,y-1,l),DoGPyramid(x,y,l+1), ...
                            DoGPyramid(x,y,l-1)];
                    end
                end
                %[~,minimum] = min(e);
                [~,maximum] = max(e);
                if(maximum == 1)
                    locs(locNum,:) = [x,y,l];
                    locNum = locNum + 1;
                end
            end
        end
    end

end
