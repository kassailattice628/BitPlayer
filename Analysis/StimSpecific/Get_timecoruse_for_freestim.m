function im = Get_timecoruse_for_freestim(app)
%%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%%%%%%%
%
% For stimuli that is almost no repetitive trials is analyzed
% without taking averaging.
%
% This function is used for MovingBar with 'Free' direction, and
%   Finemapping with 'No-grid' position.
%
%%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%%%%%%%

s = app.sobj;
im = app.imgobj;
p = app.ParamsSave;
% main = app.mainvar;

roi_positive = [];
roi_negative = [];

%% Calculate threshold for visu cell as Mean +/- 2SD
Me = mean(im.dFF(im.f0, :));
SD = std(im.dFF(im.f0, :));

threshold = 5;
Th_positive = Me + threshold*SD;
Th_negative = Me - threshold*SD;

%% Find stim ON trials
trial_stimON = [];
for i_p = 1:size(p,2)

    if ~p{i_p}.stim1.Blank
        
        % Remove trials with saccade, blink or large drift of center of the
        % pupil.
        if app.RemoveSacTrials.Value && isfield(p{i_p}, 't_saccades')
            if sum(p{i_p}.t_saccades > p{i_p}.stim1.correct_StimON_timing &...
                    p{i_p}.t_saccades < p{i_p}.stim1.correct_StimOFF_timing)
                %Skip trials
                disp(['Skip trial#:' num2str(i_p)])
                continue;
            end
        end
        trial_stimON = [trial_stimON, i_p];
    end
end
n_stimON = length(trial_stimON);
frame_stimON = zeros(1, n_stimON);


%% Set stimulus
switch s.Pattern
    case {'Moving Bar','Image Presentation'}
        stim = nan(1, n_stimON);
    case 'Fine Mapping Free'
        stim = nan(1, n_stimON);
        stim_pos = nan(2, n_stimON);
end

%% Extract timing of stim ON, and parameter of the stimulus.

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

        case 'Fine Mapping Free'
            %stim_(i) = 
            stim_pos(1, i) = p{i_p}.stim1.CenterX_pix;
            stim_pos(2, i) = p{i_p}.stim1.CenterY_pix;

        case 'Image Presentation'
            stim(i) = p{i_p}.stim1.Image_i;
    end

end

%% Set length of time points for stimulus average
[p_prestim, p_stim, p_poststim] = Set_length_averaged_timepoint(s, im);
p_data = p_prestim + p_stim + p_poststim;
im.p_prestim = p_prestim;
im.p_stim = p_stim;

%% Prepare empty vector fo average & peak amplitude

dFF_stim_average = zeros(p_data, length(stim), im.Num_ROIs);

dFF_peak_each_trials = NaN(1, length(stim), im.Num_ROIs);
Peak_each = dFF_peak_each_trials;
Peak_each_inverted = dFF_peak_each_trials;

% sort stim order
[sort_stim, i_sort] = sort(stim);
n_stim = length(sort_stim);

for i_ROI = 1:im.Num_ROIs
    if isnan(im.dFF(1, i_ROI))
        % Skip no-data ROIs
        disp(['ROI# ', num2str(i_ROI), ' has no data.'])
        continue;
    end

    for i_stim = 1:n_stim

        % Select peri stimulus frames
        ii_stim = i_sort(i_stim);
        extracted_frames = ...
            frame_stimON(ii_stim) - p_prestim : ...
            frame_stimON(ii_stim) + p_stim + p_poststim - 1;

        % Check frames
        if min(extracted_frames) >= 0 &&...
                max(extracted_frames) <= size(im.dFF, 1)

            dFF_extracted = im.dFF(extracted_frames, i_ROI);
            dFF_extracted_0set = dFF_extracted - mean(dFF_extracted(p_prestim));

            % Positive peak
            if max(dFF_extracted_0set) >= 0
                Peak_each(1, i_stim, i_ROI) =...
                    max(dFF_extracted_0set(p_prestim+1 : end));
            end

            % Negative peak
            if min(dFF_extracted_0set) < 0
                Peak_each_inverted(1, i_stim, i_ROI) =...
                    min(dFF_extracted_0set(p_prestim+1 : end));
            end

            % Extracted trace
            % dFF_stim_average(:, i_stim, i_ROI) = dFF_extracted - dFF_extracted(1);
            dFF_stim_average(:, i_stim, i_ROI) = dFF_extracted;
        end
    end

    %% Delete outlierd peak
    Peak_each= Delete_event_for_trial_average(Peak_each, i_ROI);
    Peak_each_inverted = Delete_event_for_trial_average(Peak_each_inverted, i_ROI);

    %% Classify the ROI into roi_positive or roi_negative
%     Peak_positive = max(dFF_stim_average(:,:,i_ROI), [], 'all');
%     Peak_negative = min(dFF_stim_average(:,:,i_ROI), [], 'all');

    Max_Peak_p = min(maxk(Peak_each(:,:,i_ROI),5));
    Max_Peak_n = max(mink(Peak_each_inverted(:,:,i_ROI),5));

    % Judging positive/negative ROIsa

    if Max_Peak_p > Th_positive(i_ROI)
        roi_positive = [roi_positive, i_ROI];
    end
    
    if Max_Peak_n < Th_negative(i_ROI)
        roi_negative = [roi_negative, i_ROI];
    end


end

%% Remove 0 data
% dFF_peak_each_trials(dFF_peak_each_trials == 0) = NaN;
% Peak_each(Peak_each == 0) = NaN;
% Peak_each_inverted(Peak_each_inverted == 0) = NaN;



%% Update imgobj
im.dFF_stim_average = dFF_stim_average;
% im.dFF_peak_each = dFF_peak_each_trials;
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

%% Update imgobj
im.bstrpDone = false;
app.imgobj = im;

im.Me = Me;
im.SD = SD;
im.Me2SD = Me + 2*SD;
im.Me_minus_2SD = Me - 2*SD;

%% Update GUI
app.Bootstrap.Enable = 'on';
app.newbootstrapCheckBox.Enable = 'on';
app.ShowColormap.Enable = 'on';
app.ShowSelected.Enable = 'on';
app.ShowTuningSelected.Enable = 'on';
app.ShowROIMap.Enable = 'on';

end