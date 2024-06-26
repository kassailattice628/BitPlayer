function Get_Trial_Averages_for_timecourse(app, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get traial averages for each stimulus
%
% im.dFF_s_mean :: mean values from dFF_s_each
%
% Separate plot part (180406)
% To modulate each roi, add, specifying roi number.
% Appdesigner version (191101)
% BitPlayer version (20230306)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = app.sobj;
im = app.imgobj;
p = app.ParamsSave;
main = app.mainvar;

%%%%%%%%%%

if nargin == 1
    % Use all ROIs
    selected_ROIs = 1:im.Num_ROIs;
else
    % Use selected ROI(s)
    selected_ROIs = varargin(1);
end


frame_stimON = nan(size(p, 2), 1);
stim = frame_stimON;

roi_positive = [];
roi_negative = [];

threshold = 5;

%% Collect the number(s) for each stimulus parameter.

for i = 1:size(p, 2) % Extract stimulus 

    % Select stim ON trials
    if isfield(p{i}.stim1, 'correct_StimON_timing')
        ON = p{i}.stim1.correct_StimON_timing;
    else
        continue;
    end

    % Skip stim after the imaging was already done.
    if ON > im.FVt(end)
        continue;
    end
    
    if ~isempty(ON)
        % Nearest frame to stim on timing;
        ii = knnsearch((im.FVt)', ON);
        if (im.FVt(ii) - ON) <= 0
            ii = ii + 1;
        end
        frame_stimON(i) = ii;


        %stim specific index
        switch s.Pattern
            case 'Uni'
                stim(i) = p{i}.stim1.Center_position;
            
            case 'Looming'
                stim(i) = p{i}.stim1.Center_position;

            case 'Size Random'
                stim(i) = p{i}.stim1.Size_deg;
                
            case 'Fine Mapping'
                stim(i) = p{i}.stim1.Center_position_in_FineMapArea;
                
            case 'Moving Bar'
                stim(i) = p{i}.stim1.Movebar_Direction_angle_deg;
            
            case 'Moving Spot'
                stim(i) = p{i}.stim1.Movespot_Direction_angle_deg;

            case 'Static Bar'
                stim(i) = p{i}.stim1.Bar_Orientation_angle_deg;
                
            case 'Image Presentation'
                stim(i) = p{i}.stim1.Image_i;
                
            case {'Sinusoidal', 'Shifting Grating', 'Gabor'}
                stim(i) = p{i}.stim1.Grating_Angle_deg;
            
            case 'Random Dot Motion'
                stim(i) = p{i}.stim1.MoveDirection_deg;

%             case 'Decode test_v1'
%                 stim(i) = p{i}.stim1.Image_i;
% 
%             case 'Decode SC_v1'
%                 stim(i) = i - s.Blankloop_times;
%             
%             case 'Decode test_v2'
%                 stim(i) = p{i}.stim1.Image_i;

            case 'Decode SC_v2'
                if strcmp(p{i}.stim1.subPattern, 'MovingBar')
                    % Moving Bar
                    stim(i) = p{i}.stim1.Movebar_Direction_angle_deg;
                else
                    % Checker
                    stim(i) = 1;
                end

            case 'Decode test_v2'
                if strcmp(p{i}.stim1.subPattern, 'MovingBar')
                    % Moving Bar
                    stim(i) = p{i}.stim1.Movebar_Direction_angle_deg;
                else
                    % Image #
                    stim(i) = p{i}.stim1.Image_i;
                end

            case {'ImageNet train', 'ImageNet test'}

                if strcmp(p{i}.stim1.subPattern, 'MovingBar')
                    % Moving Bar
                    stim(i) = p{i}.stim1.Movebar_Direction_angle_deg;
                else
                    % Image #
                    stim(i) = p{i}.stim1.Image_i;
                end
            otherwise
                stim(1) = 1;
        end
    end
end

%% Set length of time points for stimulus average
[p_prestim, p_stim, p_poststim] = Set_length_averaged_timepoint(s, im);
p_data = p_prestim + p_stim + p_poststim;
im.p_prestim = p_prestim;
im.p_stim = p_stim;
%% Get the number of stimuli
switch s.Pattern
    case 'Static Bar'
        stim(stim == 180) = 0;
    case {'Decode test_v2','ImageNet train', 'ImageNet test'}
        % not use MB
        stim = stim(s.Blankloop_times + 8 + 1:end);
end

[stim_list, ~, ic] = unique(stim, 'rows');

% Remove NaN
stim_list(isnan(stim_list)) = [];
n_stim = size(stim_list, 1); %the number of stimuli

%% Set 
% prepare matrix for averaged dFF
dFF_stim_average = zeros(p_data, n_stim, im.Num_ROIs);

% prepare matrix for storing peak value per trial and per stimulus type
max_n_trials = max(histcounts(stim, 'BinMethod', 'integers'));
dFF_peak_each_trials = NaN([max_n_trials, n_stim, im.Num_ROIs]);

Peak_each = dFF_peak_each_trials;
%inverted positive - negative for analyzing inhibition responses
Peak_each_inverted = dFF_peak_each_trials; 


%%
for i = selected_ROIs % i for each ROI
    if isnan(im.dFF(1, i))
        %skip no-data ROIs
        disp(['ROI# ', num2str(i), ' has no data.'])
        continue;
    end
    
    for i2 = 1:n_stim % i2 for each stimulus
        i_list = ismember(stim, stim_list(i2, :), 'rows');
        i_extracted_stim = find(i_list);
        dFF_extract = zeros(p_data, length(i_extracted_stim));
        %
        skip_i = [];
        

        % Peak values for individual trials
        for i3 = 1:length(i_extracted_stim) % i3 for each trial
            extracted_frames =...
                frame_stimON(i_extracted_stim(i3)) - p_prestim :...
                frame_stimON(i_extracted_stim(i3)) + p_stim + p_poststim -1;

            if min(extracted_frames) <= 0
                skip_i = [skip_i, i3]; %#ok<*AGROW>
                
            elseif max(extracted_frames) <= size(im.dFF, 1)
                dFF_extract(:, i3) = im.dFF(extracted_frames, i);

                % Matrix for peak values for each ROI, stimulus, trial
                Peak_each(i3, i2, i) =...
                    max(dFF_extract(:,i3)) - mean(dFF_extract(p_prestim, i3));
                
                % Inverted dFF
                inverted = max(-dFF_extract(:,i3)) - mean(-dFF_extract(p_prestim, i3));
                Peak_each_inverted(i3, i2, i) = - inverted;
            else
                %fprintf('Length of the extracted_frames is larger than the size of images! \n');
                skip_i = [skip_i, i3]; %#ok<*AGROW>
                %break;
            end
        end
        dFF_extract(:, skip_i) = [];
        
        %%%% mean traces for each stimulus & ROI
        a = mean(dFF_extract, 2);
        dFF_stim_average(:, i2, i) = a - a(1); %offset
    end

%%%%%%%%%%%
    % Clasify ROIs into roi_positive, roi_negative.
    % Both can be overlapped.

    Peak_max = max(max(dFF_stim_average(:,:,i)));
    Peak_min = min(min(dFF_stim_average(:,:,i)));

    % Store the positive and negative peak value
    if abs(Peak_max) > abs(Peak_min)
        dFF_peak_each_trials(:,:, i) = Peak_each(:,:,i);
    else
        dFF_peak_each_trials(:,:, i) = Peak_each_inverted(:,:,i);
    end

    if main.ApplydFF && main.Zscore
        if Peak_max > threshold
            roi_positive = [roi_positive, i];

        elseif Peak_min < -threshold
           roi_negative = [roi_negative, i]; 
        end

    elseif main.ApplydFF && ~main.Zscore
        F0 = mean(im.dFF(im.f0, i));
        sd_F = std(im.dFF(im.f0, i));
        if Peak_max > F0 + threshold * sd_F
            roi_positive = [roi_positive, i];

        elseif Peak_min < F0 - threshold *sd_F
            roi_negative = [roi_negative, i];
        end
    else
%%%%%%%%% Following is needed? %%%%%%%%%%
        % Use im.F rather than im.dFF.
        F0 = mean(im.F(im.f0, i));
        sd_F = std(im.F(im.f0, i));
        if Peak_max > F0 + threshold * sd_F
            roi_positive = [roi_positive, i];

        elseif Peak_min < F0 -threshold * sd_F
            roi_negative = [roi_negative, i];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

% Remove 0 data
dFF_peak_each_trials(dFF_peak_each_trials == 0) = NaN;
Peak_each(Peak_each == 0) = NaN;
Peak_each_inverted(Peak_each_inverted == 0) = NaN;

disp('Trial average of dFF is generated.')

%% Delete outlierd peak(?)
if ~isempty(dFF_peak_each_trials)
    dFF_peak_each_trials = Delete_event_for_trial_average(...
        dFF_peak_each_trials);
end

%% Update imgobj

im.dFF_stim_average = dFF_stim_average;
%peak_each_trials including both positive and negative data.
im.dFF_peak_each = dFF_peak_each_trials;

im.dFF_peak_each_positive = Peak_each;
im.dFF_peak_each_negative = Peak_each_inverted;

im.roi_positive = roi_positive;
im.roi_negative = roi_negative;

im.order_stim = ic;

% all ROIS
rois = 1:im.Num_ROIs;
% Visually responding ROIs
roi_res = union(im.roi_positive, im.roi_negative);
if size(roi_res, 2) == 1
    roi_res = roi_res';
end
im.roi_res = roi_res;
% Non-responding ROIs
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