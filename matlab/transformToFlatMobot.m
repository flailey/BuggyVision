function [ flatImage ] = transformToFlatMobot( cameraImage, tilt, pan )
%transformToFlat transforms a perspective camera image to a flat, top-down
%view of the scene

    %tilt = -1* deg2rad(.055); %.245);
    %tilt = -1* deg2rad(.5);
    pan = 0; %1* deg2rad(3.5);
    
    width = size(cameraImage,2);
    height = size(cameraImage,1);
    
    warpSize = [height*3,width*3];
    %warpSize = [1000, 1000];
    
    c2 = [1, 0,-width/2;
          0, 1,-height;
          0, 0,  1];
    
    %H = [cos(tilt),-sin(tilt),0;
    %      sin(tilt),cos(tilt),0;
    %      0,0,1];
    tiltH = [1,         0,        0;
             0, cos(tilt),sin(tilt);
             0,-sin(tilt),cos(tilt)];
    panH = [ cos(pan), sin(pan), 0;
            -sin(pan), cos(pan), 0;
                    0,        0, 1];
    
    C = [  1,  0, width*1.5;
           0,  1, height*3;
           0,  0,  1];

    flatImage = warpH(cameraImage, C*panH*tiltH*c2, warpSize ,0);

end

