function im = Get_DSI_OSI_va_Free(im)
%%%%%
%
% 'Sinusoidal', 'Shifting Grating', 'Gabor', 'Moving Bar', 'Moving Spot'
%
% im: imgobj
% rois: 1:im.Num_ROIs
% 
% BitPlayer version 20230307
% 
%%%%%

peak_positive = im.dFF_peak_each_positive;
peak_negative = im.dFF_peak_each_negative;

% Store *preferred Ang:angle and L:gDSI
Ang = zeros(1, im.Num_ROIs);
L = Ang;
Ang_ori = Ang;
L_ori = Ang;

Ang_nega = Ang;
L_nega = Ang;
Ang_ori_nega = Ang;
L_ori_nega = Ang;



rois = 1 : im.Num_ROIs;
%%
for i = rois
    StimAngles = deg2rad(im.stim_sorted);
    StimAngles_neg = StimAngles;
    % mean pkea value;
    y_positive = peak_positive(1,:,i);
    y_negative = -peak_negative(1,:,i);

    %remove nan
    i_rem = isnan(y_positive);
    y_positive(i_rem) = [];
    StimAngles(i_rem) = [];

    i_rem = isnan(y_negative);
    y_negative(i_rem) = [];
    StimAngles_neg(i_rem) = [];

    %remove negative valiue
    y_positive(y_positive < 0) = 0;
    y_negative(y_negative < 0) = 0;

    if length(y_positive) ~= length(StimAngles)
        disp(i)
    end
    % vector average for direction
    [L(i), Ang(i)] = ...
        VectorAveraging(y_positive, StimAngles, 'Direction');
    [L_nega(i), Ang_nega(i)] = ...
        VectorAveraging(y_negative, StimAngles_neg, 'Direction');

    % vector average for orientation
    [L_ori(i), Ang_ori(i)] = ...
        VectorAveraging(y_positive, StimAngles, 'Orientation');
    [L_ori_nega(i), Ang_ori_nega(i)] = ...
        VectorAveraging(y_negative, StimAngles_neg, 'Orientation');
end


StimAngles = deg2rad(im.stim_sorted);
im.stim_directions = StimAngles;
im.Ang_DS= [Ang; Ang_nega];
im.L_DS = [L; L_nega];

disp('Calculated DSI by vector averaging for Free Stim')

im.Ang_OS= [Ang_ori; Ang_ori_nega];
im.L_OS = [L_ori; L_ori_nega];

disp('Calculated OSI by vector averaging for Free Stim')
end