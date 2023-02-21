function Plot_next(app)
%
% Plot daq data
% Plot_next(app, set_n, flag)
%

data = app.SaveData;
t = app.SaveTimestamps;
n = app.n_in_loop;

%% Update GUI
%Update_text(app);


%% Photo sensor

[ON, OFF] = Get_stim_timing(app); %+ add stim timing, plot photosensor

app.ParamsSave{1,n}.stim1.correct_StimON_timing = ON;
app.ParamsSave{1,n}.stim1.correct_StimOFF_timing = OFF;


%% Locomotion (Rotary encoder)
[~, locomotion_velocity] = Decode_Rotary_Encoder(data(:, 7, n), app.recobj.sampf);
Set_plot(app.UIAxes_4, t(1:end-1, n), locomotion_velocity, [ON, OFF]);


%% Eye movment velocity
eye_velocity = Get_eye_velocity(data(:, 1:2, n), app.recobj.sampf);
Set_plot(app.UIAxes_3, t(1:end-1, n), eye_velocity, [ON, OFF]);

% Get detect saccade
[locations, ~] = Get_detect_saccade(eye_velocity, app.recobj.sampf,...
    [app.Threshold_saccade_low.Value, app.Threshold_saccade_high.Value]);

t_saccades = t(locations, n);
Update_text_detected_saccade(app.Detected_saccade, t_saccades);
Add_plot_saccade(app.UIAxes_3, t_saccades, eye_velocity(locations));

%% eye horizontal
Set_plot(app.UIAxes_1, t(:, n), data(:, 1, n), [ON, OFF]);
Add_plot_saccade(app.UIAxes_1, t_saccades, data(locations, 1, n));

%% eye vertical
Set_plot(app.UIAxes_2, t(:, n), data(:, 2, n), [ON, OFF]);
Add_plot_saccade(app.UIAxes_2, t_saccades, data(locations, 2, n));

 






end