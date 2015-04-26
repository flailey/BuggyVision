% takes in the regular video and makes a 'flat video' from a bird's view


vid = loadVideo(1);

myVideo = VideoWriter('../outputs/flatVideo1.avi');

uncompressedVideo = VideoWriter('myfile.avi', 'Uncompressed AVI');

myVideo.FrameRate = 20;  % Default 30
myVideo.Quality = 75;    % Default 75

open(myVideo);

numFrames = vid.NumberOfFrames;
tic;
for i = 1:1:numFrames
    % progress marker every 100 images
    if mod(i, 25) == 0 || i == 2
        elapsed = toc;
        total = elapsed * numFrames/i;
        remaining = total - elapsed;
        fprintf('%.2f%%   Approximately %.1f minutes remaining\n',i / numFrames * 100,remaining/60);
    end
    
    frame = read(vid,i);
    flatFrame = transformToFlat(frame);

    writeVideo(myVideo, flatFrame);
end

close(myVideo);