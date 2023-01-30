function imaq_Reset_Saccade(app)
%%
%
% After reset roi, imaq setting shoud be changed.
%
%%
imaq = app.imaq;
imaq.frame_rate = 500;

%Update selected ROI
imaq.vid.ROIPosition = imaq.roi_position;



%Recording time
rec_time = app.recobj.rect/1000; % in sec
imaq.vid.FramesPerTrigger = rec_time * imaq.frame_rate; %
imaq.vid.TriggerFrameDelay = 0;

% Save Mode
imaq.vid.LoggingMode = 'disk'; % 'disk' or 'memory'
triggerconfig(imaq.vid, 'hardware', 'risingEdge', 'externalTriggerMode0-Source0');

% Other settings
imaq.src.Exposure = 1.358;
%imaq.src.FrameRatePercentage = 100;
imaq.src.Gain = 11.398;
imaq.src.Shutter = 1.924;

%% Return
app.imaq = imaq;

end