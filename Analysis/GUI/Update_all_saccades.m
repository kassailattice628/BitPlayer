function Update_all_saccades(app)
%
% Re-calcurate all saccade from all traials.
%

p = app.ParamsSave;
t = app.SaveTimestamps;
data = app.SaveData;
th = app.Threshold_photo_sensor.Value;

if ~isfield(app.sobj, 'Blankloop_times')
    app.sobj.Blankloop_times = 0;
end

%%
disp('Update all saccades...')

n_trials = min(size(p,2), size(t, 2));

max_h = [];
min_h = [];
max_v = [];
min_v = [];

blank_ = app.sobj.Blankloop_times;
sampf = app.recobj.sampf;
Thres_low = app.Threshold_saccade_low.Value;
Thres_high = app.Threshold_saccade_high.Value;

for i = 1:n_trials
    
    % Extract stim timing
    if i > blank_
    
        [ON, OFF] = Get_stim_timing(t, data, i, p, th); 

    else
        ON = [];
        OFF = [];
    end

    p{1,i}.stim1.correct_StimON_timing = ON;
    p{1,i}.stim1.correct_StimOFF_timing = OFF;
    
    % Rotary encoder
    if ~isfield(p{1, i}, 'locomotion_velocity')
        [~, locomotion_velocity] = Decode_Rotary_Encoder(data(:, 7, i), sampf);
        p{1,i}.locomotion_velocity = locomotion_velocity;
    end
    
    % Eye velocity
    if ~isfield(p{1, i}, 'eye_velocity')
        eye_velocity = Get_eye_velocity(data(:, 1:2, i), sampf);
        p{1,i}.eye_velocity = eye_velocity;
    end
    
    % Detect saccade
    [locations, ~] = Get_detect_saccade(...
        p{1,i}.eye_velocity, sampf,...
        [Thres_low, Thres_high]);
    
    t_saccades = t(locations, i);
    p{1,i}.p_saccades = locations; %time point
    p{1,i}.t_saccades = t_saccades; %time


    max_h = [max_h, max(data(:,1, i))];
    min_h = [min_h, min(data(:,1, i))];
    max_v = [max_v, max(data(:,2, i))];
    min_v = [min_v, min(data(:,2, i))];


    %process progressing info.
    if rem(i, 20) == 0
        fprintf('Processing trial# %d ...\n', i);
    end
end
disp('Done...')

%% Return
app.n_in_loop = i;
app.Trial_n.Value = i;
app.ParamsSave = p;

app.Max_H = max(max_h);
app.Min_H = min(min_h);
app.Max_V = max(max_v);
app.Min_V = min(min_v);

end