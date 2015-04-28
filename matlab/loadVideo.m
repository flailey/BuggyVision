function [ vid ] = loadVideo( videoNumber )
%LoadVideo loads the video run for testing
    %vid = VideoReader('../data/BuggyRun1.mov');
    if videoNumber == 2
        vid = VideoReader(strcat('../data/large/Icarus.mp4'));
    elseif videoNumber == 3 
        vid = VideoReader(strcat('../data/large/mobot1.mov'));  
    end
    %vid = VideoReader(strcat('../data/Ascension', int2str(videoNumber), '.mp4'));
    %numFrames = vid.NumberOfFrames;
    %frames = read(vid,i);

end
