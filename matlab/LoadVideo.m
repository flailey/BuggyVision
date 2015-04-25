function [ vid ] = LoadVideo( videoNumber )
%LoadVideo loads the video run for testing
    vid=VideoReader(strcat('../data/BuggyRun', videoNumber, '.avi'));
    %numFrames = vid.NumberOfFrames;
    %frames = read(vid,i);

end

