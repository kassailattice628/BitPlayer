function im = Get_timecoruse_for_freestim(app)
% %%%%%%%%%%
% For stimuli that is almost no repetitive trials is analyzed
% without taking averaging.
%
% This function is used for MovingBar with 'Free' direction, and
%   Finemapping with 'No-grid' position.
%
% %%%%%%%%%%%

s = app.sobj;
im = app.imgobj;
p = app.ParamsSave;
main = app.mainvar;


%% Find stim ON trials
trial_stimON = [];

for i_p = 1:size(p,2)
    if ~p{i_p}.stim1.Blank
        trial_stimON = [trial_stimON, i_p];
    end
end
n_stimON = length(trial_stimON);
frame_stimON = zeros(1, n_stimON);
threshold = 2;
roi_positive = [];
roi_negative = [];

%%
switch s.Pattern
    case {'Moving Bar','Image Presentation'}
        stim = nan(1, n_stimON);
    case 'Fine Mapping'
        stim = nan(2, n_stimON);
end

%%
for i = 1:n_stimON
    i_p = trial_stimON(i);

    % Get stim On trials and its timing
    if isfield(p{i_p}.stim1, 'correct_StimON_timing')
        ON = p{i_p}.stim1.correct_StimON_timing;
    else
        stim(:, i) = [];
        break;
    end


    if ~isempty(ON)
        ii = knnsearch((im.FVt)', ON);
        if (im.FVt(ii) - ON) >= 0
            ii = ii - 1;
        end
        frame_stimON(i) = ii;
    end

    switch s.Pattern
        case 'Moving Bar'
            stim(i) = p{i_p}.stim1.Movebar_Direction_angle_deg;

        case 'Fine Mapping'
            stim(1, i) = p{i_p}.stim1.x;
            stim(2, i) = p{i_p}.stim1.y;

        case 'Image Presentation'
            stim(i) = p{i_p}.stim1.Image_i;
    end

end

%% Set length of time points for stimulus average
[p_prestim, p_stim, p_poststim] = Set_length_averaged_timepoint(s, im);
p_data = p_prestim + p_stim + p_poststim;
im.p_prestim = p_prestim;
im.p_stim = p_stim;

%%
dFF_stim_average = zeros(p_data, length(stim), im.Num_ROIs);
dFF_peak_each_trials = NaN(1, length(stim), im.Num_ROIs);
Peak_each = dFF_peak_each_trials;
Peak_each_inverted = dFF_peak_each_trials;

[sort_stim, i_sort] = sort(stim);
n_stim = length(sort_stim);

for i_ROI = 1:im.Num_ROIs
    if isnan(im.dFF(1, i_ROI))
        %skip no-data ROIs
        disp(['ROI# ', num2str(i_ROI), ' has no data.'])
        continue;
    end

    for i_stim = 1:n_stim
        ii_stim = i_sort(i_stim);
        extracted_frames = ...
            frame_stimON(ii_stim) - p_prestim : ...
            frame_stimON(ii_stim) + p_stim + p_poststim - 1;

        if min(extracted_frames) >= 0 &&...
                max(extracted_frames) <= size(im.dFF, 1)
            dFF_extracted = im.dFF(extracted_frames, i_ROI);
            % Peak value
            Peak_each(1, i_stim, i_ROI) = ...
                max(dFF_extracted) - mean(dFF_extracted(p_prestim));

            % Inverted dFF
            inverted = max(-dFF_extracted) - mean(-dFF_extracted(p_prestim));
            Peak_each_inverted(1, i_stim, i_ROI) = - inverted;
            %end

            % individual extraced traces
            dFF_stim_average(:, i_stim, i_ROI) = dFF_extracted - dFF_extracted(1);
        end
    end

%% Classify ROIs into roi_positive or roi_negative
Peak_max = max(max(dFF_stim_average(:,:,i_ROI)));
Peak_min = min(min(dFF_stim_average(:,:,i_ROI)));

    % Store the positive and negative peak value
    if abs(Peak_max) > abs(Peak_min)
        dFF_peak_each_trials(1,:, i_ROI) = Peak_each(1,:,i_ROI);
    else
        dFF_peak_each_trials(1,:, i_ROI) = Peak_each_inverted(1,:,i_ROI);
    end

    if main.ApplydFF && main.Zscore
        if Peak_max > threshold
            roi_positive = [roi_positive, i_ROI];
        elseif Peak_min < -threshold
            roi_negative = [roi_negative, i_ROI];
        end

    elseif main.ApplydFF && ~main.Zscore
        F0 = mean(im.dFF(im.f0, i_ROI));
        sd_F = std(im.dFF(im.f0, i_ROI));
        if Peak_max > F0 + threshold * sd_F
            roi_positive = [roi_positive, i_ROI];

        elseif Peak_min < F0 - threshold *sd_F
            roi_negative = [roi_negative, i_ROI];
        end
    end

end

%% Remove 0 data
dFF_peak_each_trials(dFF_peak_each_trials == 0) = NaN;
Peak_each(Peak_each == 0) = NaN;
Peak_each_inverted(Peak_each_inverted == 0) = NaN;

%% Delete outlierd peak
if ~isempty(dFF_peak_each_trials)
    dFF_peak_each_trials = Delete_event_for_trial_average(...
        dFF_peak_each_trials);
end

%% Update imgobj
im.dFF_stim_average = dFF_stim_average;
im.dFF_peak_each = dFF_peak_each_trials;
im.dFF_peak_each_positive = Peak_each;
im.dFF_peak_each_negative = Peak_each_inverted;
im.roi_positive = roi_positive;
im.roi_negative = roi_negative;
im.stim_sorted = sort_stim;
im.stim_i_sort = i_sort;

rois = 1:im.Num_ROIs;
roi_res = union(im.roi_positive, im.roi_negative);
if size(roi_res, 2) == 1
    roi_res = roi_res';
end
im.roi_res = roi_res;
im.roi_nores = setdiff(rois, im.roi_res);


%% Calculate threshold for visu cell as Mean +/- 2SD
% is 2SD appropriate?
Me = mean(im.dFF(im.f0, :));
SD = std(im.dFF(im.f0, :));
im.Me = Me;
im.SD = SD;
im.Me2SD = Me + 2*SD;
im.Me_minus_2SD = Me - 2*SD;

%% Update imgobj
im.bstrpDone = false;
app.imgobj = im;

%% Update GUI
app.Bootstrap.Enable = 'on';
app.newbootstrapCheckBox.Enable = 'on';
app.ShowColormap.Enable = 'on';
app.ShowSelected.Enable = 'on';
app.ShowTuningSelected.Enable = 'on';
app.ShowROIMap.Enable = 'on';

end