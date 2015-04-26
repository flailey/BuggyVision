function displayFeatures( image )
    image = rgb2gray(image);
    image = im2double(image);
    levels = [-1,0,1,2,3,4];
    sigma0 = 1;
    k = sqrt(2);
    th_contrast = 0.03;
    th_r = 12;
    [points,~] = DoGdetector(image, sigma0, k, levels, th_contrast, th_r);
    load('testPattern.mat');
    [points,~] = computeBrief(image, points, levels, compareX, compareY)
    hold off;
    imshow(image);
    hold on;
    plot(points(:,2), points(:,1), 'g.');
    hold off;


end
