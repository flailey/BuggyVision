function [ flatImage ] = transformToFlat( cameraImage )
%transformToFlat transforms a perspective camera image to a flat, top-down
%view of the scene

    tilt = -1* deg2rad(.25);
    
    warpSize = [2000,2000];
    %warpSize = [1000, 1000];
    
    C = eye(3);
    H = eye(3);
    c2 = eye(3);
    
    
    c2 = [1, 0,-400;
         0, 1,-320;
         0, 0,1];
    
    %H = [cos(tilt),-sin(tilt),0;
    %      sin(tilt),cos(tilt),0;
    %      0,0,1];
    H = [1,0,0;
         0,cos(tilt),sin(tilt);
         0,-sin(tilt),cos(tilt)];
    
    C = [1,0,400 + 500;
          0,1,320 + 1200;
          0,0,1];

    flatImage = warpH(cameraImage, C*H*c2, warpSize ,0);

end

