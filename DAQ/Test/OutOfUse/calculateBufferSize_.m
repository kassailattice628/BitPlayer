function [bufferSize, bufferTimeSpan] = calculateBufferSize(~, callbackTimeSpan, liveViewTimeSpan, captureDuration, rate)
%input 
% "callbackTimeSpan" is the wall-clock timespan (sec) of the data read in DAQ
% ScanAvailabke callback function
% "liveViewTimeSpan" is the wall-clock timespan (sec) of the DAQ data in the
% live view plot
% "captureDuration" is the total capture duration (sec)
% "rate" is the DAQ sampling rate (src.Rate or app.recobj.sampf)

%output
% "buffersize" is the calculated buffer size (number of scans)
% "bufferTimeSpan" is the wall-clock timespan (sec) of cprresponding to
% <buffersize> scans.

bufferTimeSpan = max([captureDruation, liveViewTimeSpan]) + 2*liveViewTimeSpan;
bufferSize = ceil(rate * bufferTimeSpan) + 1;