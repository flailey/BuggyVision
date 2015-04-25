function [ flatImage ] = transformToFlat( cameraImage )
%transformToFlat transforms a perspective camera image to a flat, top-down
%view of the scene

    tilt = deg2rad(20);
    
    warpSize = [600, 600];

    H = [1,0,0; ...
         0,sin(tilt),-sin(tilt); ...
         0,cos(tilt),cos(tilt)];

    flatImage = warpH(cameraImage, H, warpSize ,0);

end

