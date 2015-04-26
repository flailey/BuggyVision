function [ H ] = findTransform( pts )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

numpts = size(pts,2);

x1 = pts(1,:);
y1 = pts(2,:);
x2 = pts(3,:);
y2 = pts(4,:);

x1mean = mean(x1);
y1mean = mean(y1);
x2mean = mean(x2);
y2mean = mean(y2);

%% subtract mean to find rotation
pts1_0mean = [x1-x1mean; y1-y1mean];%, ones(numpts,1)];
pts2_0mean = [x2-x2mean; y2-y2mean];%, ones(numpts,1)];

H = zeros(2);
for i = 1:numpts
    point1 = pts1_0mean(:,i);
    point2 = pts2_0mean(:,i);
    H = H + point1*point2';
end

[U,S,V] = svd(H);
R = V*U';

%% address reflection case
if det(R) < 0
    R(:,2) = -1*R(:,2);
end

%% find translation
t = -1*R*[x1mean; y1mean] + [x2mean; y2mean];

%% put it together
H = [ R, t;
     0,0,1];

end

