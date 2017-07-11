function [  ] = processVTNRawImage( image )
%PROCESSVTNRAWIMAGE Summary of this function goes here
%   Detailed explanation goes here
    vtnModerate = [128 0 0];
    vtnIntense = [255 0 0];
    
    %Have to check if this is real. Looks like if they were the cells. But
    %they are bigger than usual.
    vtnLow = [0 128 0];
    
    %Seems to be fibre. We want to capture all the blue region within the
    %VTN images.
    blueZoneRangeInit = [30 70 215];
    blueZoneRangeEnd = [150 200 255];
    

end

