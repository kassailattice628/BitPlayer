function imaq_ini(app)
%Setup USB Camera for eye recording
%
% Setting info: Matlab App -> Image Acquisition EXplorer 
% for R2022a
%
%  2022/01/17
% -> Cannot record at 500 Hz....
% Try to change setting by IAE 2022/01/31
%

imaqreset;


CheckDuration_Camera(app);
imaq = app.imaq;

% Connect to Device%
%{
Mode 0 is the standard imaging mode with full resolution readout.
Mode 1 is 2x2 binning. Effetive resolution is reduced by half and image
brightness is increased all cases.
Mode 5 is 4x4binning. Effective resollution is reduced by a factor of four.
Mode 7 optimize highe well depth, SNR, quantum efficiency at the expense of
frame rate 
%}

%% Image aquisition exploer 20220131 %%
imaq.vid = videoinput("pointgrey", 1, "F7_Mono8_960x600_Mode1");
imaq.vid.ROIPosition = [420  204  160  152];
imaq.vid.LoggingMode = 'disk';

imaq.src = getselectedsource(imaq.vid);
imaq.src.FrameRate = 500;
imaq.src.Strobe1 = "On";

% Need to check Exposure, Shutter, and so on...
% imaq.src.Exposure = 1.358;
% imaq.src.ExposureMode = "Manual";
% imaq.src.Gain = 11.398;
% imaq.src.GainMode = "Manual";
% imaq.src.Shutter = 1.924;
% imaq.src.ShutterMode = "Manual";

%% old setting 
%{
imaq.vid = videoinput('pointgrey', 1, 'F7_Raw8_1920x1200_Mode7');
% videoinput('pointgrey', 1, 'F7_Raw8_960x600_Mode1');

% ROI selection
imaq.vid.ROIPosition = [308, 174, 140, 140];
%imaq.vid.ROIPosition = [308, 174, 192, 168];

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
%}

%% Recoding setting
%Recording time

%These are set in CheckDuration_Camera.m
%app.imaq.duration_ms = app.VideoCaptureTime.Value;
%app.imaq.delay_ms = app.VideoCaptureDelay.Value;

video_rec_time =app.VideoCaptureTime.Value/1000; % in sec
imaq.vid.FramesPerTrigger = video_rec_time * imaq.src.FrameRate; %
imaq.vid.TriggerRepeat = 0;
imaq.vid.TriggerFrameDelay = 0; %if needed, add GUI

% Save Mode
imaq.vid.LoggingMode = 'disk'; % 'disk' or 'memory'

% Set external trigger and trigger source?
triggerconfig(imaq.vid, 'hardware', 'risingEdge', 'externalTriggerMode0-Source0');


% Return
app.imaq = imaq;
end