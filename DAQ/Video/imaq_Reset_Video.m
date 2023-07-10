function imaq_Reset_Video(app)
%%
%
% After reset roi, imaq setting shoud be changed.
%
%%
imaq = app.imaq;

%% Setup Parameters
%Update selected ROI
imaq.vid.ROIPosition = imaq.roi_position;
disp(imaq.vid.ROIPosition);

imaq.src.FrameRate = app.VideoFrameRate.Value;
imaq.frame_rate = imaq.src.FrameRate; %actual FrameRate


%Recording time
video_rec_time = app.VideoCaptureTime.Value/1000; % in sec
imaq.vid.FramesPerTrigger = video_rec_time * imaq.src.FrameRate; %
imaq.vid.TriggerRepeat = 0;
delay_ms = app.VideoCaptureDelay.Value; %ms
delay_frames = round(delay_ms/1000 * imaq.frame_rate);
imaq.vid.TriggerFrameDelay = delay_frames;


% Save Mode & Trigger Mode
imaq.vid.LoggingMode = 'disk'; % 'disk' or 'memory'
triggerconfig(imaq.vid, 'hardware', 'risingEdge', 'externalTriggerMode0-Source0');

% Other settings
imaq.src.Exposure = 1.358;
%imaq.src.FrameRatePercentage = 100;
imaq.src.Gain = 11.398;
imaq.src.Shutter = 1.924;



% actual frame rate
imaq.frame_rate = imaq.src.FrameRate;
% Update imaq
app.imaq = imaq;

end