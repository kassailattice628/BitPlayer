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
% %saccade timing
% th_low = app.Vel_threshold_low.Value;
% th_high = app.Vel_threshold_high.Value;
% [locs, pks] = Update_sac(app, 0, p{1,n}, vel, recTime, th_low, th_high);
% %[locs, pks] = get_detect_saccade(p{1,n}, vel, recTime, th, 0);
% app.ParamsSave{1,n}.sac_t = recTime(locs);
% 
Set_plot(app.UIAxes_3, t(1:end-1, n), eye_velocity, [ON, OFF]);

%% eye horizontal
Set_plot(app.UIAxes_1, t(:, n), data(:, 1, n), [ON, OFF]);

%% eye vertical
Set_plot(app.UIAxes_2, t(:, n), data(:, 2, n), [ON, OFF]);

 
%% Detect Spikes;
% Add_plot_saccade(app, recTime, data(:,1:2,n), locs, pks)





end