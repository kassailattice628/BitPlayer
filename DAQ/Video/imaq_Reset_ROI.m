function imaq_Reset_ROI(app)
%
% Capture and show the single full image.
% Reset (Move) ROI in order to set the appropriate eye position.
%

imaq = app.imaq;

%
% imaq.vid = videoinput('pointgrey', 1, 'F7_Raw8_960x600_Mode1');

% Change image size for full image
imaq.vid.ROIPosition = [0, 0, 960, 600];

% Reset Capture setting
imaq.vid.FramesPerTrigger = 1;

% Change logging mode for temporal image.
imaq.vid.LoggingMode = 'memory'; % 'disk' or 'memory'
triggerconfig(imaq.vid, 'immediate');
imaq.vid.triggerRepeat = 0;

% Capture single image
start(imaq.vid)
img = getdata(imaq.vid);

% Show image
imaq.fig_ROI = figure('CloseRequestFcn',@Reset_button);

% Update "imaq.roi_position" by moving ROI on the image
set(imaq.fig_ROI, 'WindowButtonUpFcn', @GetROIPosition);

imshow(img);
axis image;

if ~isfield(imaq, 'roi_position')
    imaq.roi_position = [420  204  160  152];
end

roi = drawrectangle('Color', 'w', 'LineWidth', 1.5, 'Position', imaq.roi_position);

%% sub: Reset logging mode
    function Reset_button(~, ~)
        delete(imaq.fig_ROI)
        app.AdujstROIButton.Value = false;

        imaq_Reset_Video(app); 
    end
%% sub; Update roi_position
    function GetROIPosition(~, ~)
        app.imaq.roi_position = round(roi.Position);
        disp('New ROI position: ')
        disp(app.imaq.roi_position);
    end
end