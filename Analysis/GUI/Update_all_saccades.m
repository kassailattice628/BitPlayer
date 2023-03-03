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
for i = 1:size(t, 2)
    
    % Extract stim timing
    if i > app.sobj.Blankloop_times
    
        [ON, OFF] = Get_stim_timing(t, data, i, p, th); 

    else
        ON = [];
        OFF = [];
    end
    p{1,i}.stim1.correct_StimON_timing = ON;
    p{1,i}.stim1.correct_StimOFF_timing = OFF;
    
    % Rotary encoder
    if ~isfield(p{1, i}, 'locomotion_velocity')
        [~, locomotion_velocity] = Decode_Rotary_Encoder(data(:, 7, i), app.recobj.sampf);
        p{1,i}.locomotion_velocity = locomotion_velocity;
    end
    
    % Eye velocity
    if ~isfield(p{1, i}, 'eye_velocity')
        eye_velocity = Get_eye_velocity(data(:, 1:2, i), app.recobj.sampf);
        p{1,i}.eye_velocity = eye_velocity;
    end
    
    % Detect saccade
    [locations, ~] = Get_detect_saccade(...
        p{1,i}.eye_velocity, app.recobj.sampf,...
        [app.Threshold_saccade_low.Value,...
        app.Threshold_saccade_high.Value]);
    
    t_saccades = t(locations, i);
    p{1,i}.p_saccades = locations; %time point
    p{1,i}.t_saccades = t_saccades; %time
    
    if rem(i, 20) == 0
        fprintf('Processing trial# %d ...\n', i);
    end
end
disp('Done...')

%% Return
app.n_in_loop = i;
app.Trial_n.Value = i;
app.ParamsSave = p;

end