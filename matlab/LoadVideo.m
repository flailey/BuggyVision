function [ vid ] = loadVideo( videoNumber )
%LoadVideo loads the video run for testing
    %vid = VideoReader('../data/BuggyRun1.mov');
    vid = VideoReader(strcat('../data/BuggyRun', int2str(videoNumber), '.mov'));
    %numFrames = vid.NumberOfFrames;
    %frames = read(vid,i);

end

