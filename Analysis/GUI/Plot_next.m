function Plot_next(app)
%
% Plot daq data
% Plot_next(app, set_n, flag)
%

data = app.SaveData;
t = app.SaveTimestamps;
n = app.n_in_loop;


%% Photo sensor 
[ON, OFF] = Plot_photo_sensor(app, n);
app.ParamsSave{1,n}.stim1.correct_StimON_timing = ON;
app.ParamsSave{1,n}.stim1.correct_StimOFF_timing = OFF;

%% Locomotion (Rotary encoder)
[~, locomotion_velocity] = Decode_Rotary_Encoder(data(:, 7, n), app.recobj.sampf);
app.ParamsSave{1,n}.locomotion_velocity = locomotion_velocity;
Set_plot(app.UIAxes_4, t(1:end-1, n), locomotion_velocity, [ON, OFF]);

%% Eye movment velocity
eye_velocity = Get_eye_velocity(data(:, 1:2, n), app.recobj.sampf);
app.ParamsSave{1,n}.eye_velocity = eye_velocity;
Set_plot(app.UIAxes_3, t(1:end-1, n), eye_velocity, [ON, OFF]);


%% Update saccade and plot eye movements with deteted saccades
% If sacccades have already been detected, it is not calculated again.
% To update saccades, use GUI.
if ~isfield(app.ParamsSave{1,n}, 't_saccades')
    Update_saccade(app);
end

%% GUI_text
Update_text_detected_saccade...
    (app.Detected_saccade, app.ParamsSave{1,n}.t_saccades);
Plot_eye_movements(app)
end


