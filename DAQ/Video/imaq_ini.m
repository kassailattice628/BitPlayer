function imaq_ini(app)
%Setup USB Camera for eye recording
%
% Setting info: Matlab App -> Image Acquisition EXplorer 
% for R2022a
%
%  2022/01/17
%

imaqreset;

% Connect to Device
imaq.vid = videoinput('pointgrey', 1, 'F7_Raw8_1920x1200_Mode7');
% videoinput('pointgrey', 1, 'F7_Raw8_960x600_Mode1');

% ROI selection
imaq.vid.ROIPosition = [308, 174, 192, 168];

% Configure Device-Specific Properties
imaq.src = getselectedsource(imaq.vid);
imaq.src.Exposure = 1.358;
imaq.src.ExposureMode = "Manual";

imaq.src.FrameRate = 500;
%imaq.src.FrameRatePercentage = 100;
imaq.src.Gain = 11.398;
imaq.src.GainMode = "Manual";
imaq.src.Shutter = 1.924;
imaq.src.ShutterMode = "Manual";

%Recording time
rec_time = app.imaq.duration_ms/1000; % in sec
imaq.vid.FramesPerTrigger = rec_time * imaq.src.FrameRate; %
imaq.vid.TriggerRepeat = 0;
imaq.vid.TriggerFrameDelay = 0;

% Save Mode
imaq.vid.LoggingMode = 'disk'; % 'disk' or 'memory'

% Set external trigger and trigger source?
triggerconfig(imaq.vid, 'hardware', 'risingEdge', 'externalTriggerMode0-Source0');


% Return
app.imaq = imaq;
end