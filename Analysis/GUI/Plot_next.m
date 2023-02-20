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


%% photo sensor
th_photo = app.Threshold_photo_sensor.Value;

% [corON, corOFF] = Plot_photo_sensor(app, recTime, data(:,3,n), th_photo, n, flag);
% Show_stim_area(app.UIAxes_photosensor, data(:,3,n), corON , corOFF, 150, -0.1)


%% rotary encoder
% [~, rotVel] = DecodeRot(data(:, ch_rot, n), n, p, app.recobj.sampf);
% Set_plot(app.UIAxes_Locomotion, recTime(1:end-1), rotVel)
% Show_stim_area(app.UIAxes_Locomotion, rotVel, corON , corOFF, [], [])


%% eye velocity
% [~, ~, vel] = get_eye_velocity(app.recobj.sampf, data(:,1:2,n));
% %saccade timing
% th_low = app.Vel_threshold_low.Value;
% th_high = app.Vel_threshold_high.Value;
% [locs, pks] = Update_sac(app, 0, p{1,n}, vel, recTime, th_low, th_high);
% %[locs, pks] = get_detect_saccade(p{1,n}, vel, recTime, th, 0);
% app.ParamsSave{1,n}.sac_t = recTime(locs);
% 
% %eye velocity
% Set_plot(app.UIAxes_Eye_Velo, recTime(1:end-1), vel);
% Show_stim_area(app.UIAxes_Eye_Velo, vel, corON , corOFF, 2, -0.01)

%% eye horizontal
Set_plot(app.UIAxes_1, t(:, n), data(:, 1, n));
%Show_stim_area(app.UIAxes_Eye_Horizontal, data(:,1, n), corON , corOFF, [], [])

%% eye vertical
Set_plot(app.UIAxes_2, t(:, n), data(:, 2, n));
% Show_stim_area(app.UIAxes_Eye_Vertical, data(:,2, n), corON , corOFF, [], [])
% 
% %% Detect Spikes;
% Add_plot_saccade(app, recTime, data(:,1:2,n), locs, pks)

%% Photo sensor
Set_plot(app.UIAxes_3, t(:, n), data(:, 3, n));


%drawnow;

end