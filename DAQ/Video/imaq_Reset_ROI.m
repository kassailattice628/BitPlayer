function imaq_Reset_ROI(app)
%
% Capture and show the single full image.
% Move ROI area in order to capture the eye.
%

imaq = app.imaq;

% imaqreset;
% if isfield(imaq, 'vid')
%     delete(imaq.vid)
% end

%%
%imaq.vid = videoinput('pointgrey', 1, 'F7_Raw8_960x600_Mode1');
% ROI selection
imaq.vid.ROIPosition = [0 0 960, 600];
%imaq.src = getselectedsource(imaq.vid);

%Capture setting
imaq.vid.FramesPerTrigger = 1;
% imaq.frame_rate = 500;
% imaq.src.Exposure = 1.358;
% %imaq.src.FrameRatePercentage = 100;
% imaq.src.Gain = 11.398;
% imaq.src.Shutter = 1.924;
% Save Mode
imaq.vid.LoggingMode = 'memory'; % 'disk' or 'memory'
triggerconfig(imaq.vid, 'immediate');
imaq.vid.triggerRepeat = 0;

% Capture single image
start(imaq.vid)
img = getdata(imaq.vid);
% Show image
imaq.fig_ROI = figure('CloseRequestFcn',@Reset_button);
set(imaq.fig_ROI, 'WindowButtonUpFcn', @GetROIPosition);
imshow(img);
axis image;


if ~isfield(imaq, 'roi_position')
    imaq.roi_position = [380, 174, 192, 168];
end

roi = drawrectangle('Color', 'w', 'LineWidth', 1.5, 'Position', imaq.roi_position);

%% Return
app.imaq = imaq;

%% subfunction
    function Reset_button(~, ~)
        delete(imaq.fig_ROI)
        app.AdujstROIButton.Value = false;

        imaq_Reset_Saccade(app);
        
    end

%
    function GetROIPosition(~, ~)
        imaq.roi_position = round(roi.Position);
        disp('New ROI position: ')
        disp(imaq.roi_position);
    end
end