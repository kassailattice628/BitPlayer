function im = Get_DSI_va(im)
%%%%%
%
% 'Sinusoidal', 'Shifting Grating', 'Gabor', 'Moving Bar', 'Moving Spot'
%
% im: imgobj
% rois: 1:im.Num_ROIs
% 
% BitPlayer version 20230307
%%%%%

peak_positive = im.dFF_peak_each_positive;
peak_negative = im.dFF_peak_each_negative;
n_stim = size(peak_positive, 2);

% Store *preferred Ang:angle and L:gDSI
Ang = zeros(1, im.Num_ROIs);
L = Ang;

Ang_nega = Ang;
L_nega = Ang;

StimAngles = linspace(0, (2*pi - 2*pi/n_stim), n_stim);

rois = 1 : im.Num_ROIs;
%%
for i = rois 
    % mean pkea value;
    y_positive = mean(peak_positive(:,:,i), 'omitnan');
    y_negative = mean(-peak_negative(:,:,i), 'omitnan');

    y_positive(y_positive < 0) = 0;
    y_negative(y_negative < 0) = 0;


    % vector average for orientation
    [L(i), Ang(i)] = VectorAveraging(y_positive, StimAngles, 'Direction');
    [L_nega(i), Ang_nega(i)] = VectorAveraging(y_negative, StimAngles, 'Direction');
end

im.stim_directions = StimAngles;
im.Ang_DS= [Ang; Ang_nega];
im.L_DS = [L; L_nega];

disp('Calculated DSI by vector averaging')

end

%%%%%%%%%%

