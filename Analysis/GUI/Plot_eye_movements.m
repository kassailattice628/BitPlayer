function Plot_eye_movements(app)
%
%
%
p = app.ParamsSave;
n = app.n_in_loop;
t = app.SaveTimestamps;
d = app.SaveData;

ON = p{1,n}.stim1.correct_StimON_timing;
OFF = p{1,n}.stim1.correct_StimOFF_timing;
t_saccades = p{1,n}.t_saccades;
locations = p{1,n}.p_saccades;


%% Plot
% Velocity
Set_plot(app.UIAxes_3, t(1:end-1, n), p{1,n}.eye_velocity, [ON, OFF]);
Add_plot_saccade(app.UIAxes_3, t_saccades, p{1,n}.eye_velocity(locations));

% Horizontal
Set_plot(app.UIAxes_1, t(:, n), d(:, 1, n), [ON, OFF]);
Add_plot_saccade(app.UIAxes_1, t_saccades, d(locations, 1, n));

% Vertical
Set_plot(app.UIAxes_2, t(:, n), d(:, 2, n), [ON, OFF]);
Add_plot_saccade(app.UIAxes_2, t_saccades, d(locations, 2, n));
end