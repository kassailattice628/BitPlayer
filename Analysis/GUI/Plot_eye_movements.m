function Plot_eye_movements(app)
%
% Plot horizontal & vertical eye movements, and radial velocity of the
% pupil center.
% Add detected saccade if exists.
%
%%
p = app.ParamsSave;
n = app.n_in_loop;
t = app.SaveTimestamps;
data = app.SaveData;

ON = p{1,n}.stim1.correct_StimON_timing;
OFF = p{1,n}.stim1.correct_StimOFF_timing;
t_saccades = p{1,n}.t_saccades;
p_saccades = p{1,n}.p_saccades;


%% Plot
% Velocity
Set_plot(app.UIAxes_3, t(1:end-1, n), p{1,n}.eye_velocity, [ON, OFF]);
Add_plot_saccade(app.UIAxes_3, t_saccades, p{1,n}.eye_velocity(p_saccades));

% Horizontal
Set_plot(app.UIAxes_1, t(:, n), data(:, 1, n), [ON, OFF]);
Add_plot_saccade(app.UIAxes_1, t_saccades, data(p_saccades, 1, n));

% Vertical
Set_plot(app.UIAxes_2, t(:, n), data(:, 2, n), [ON, OFF]);
Add_plot_saccade(app.UIAxes_2, t_saccades, data(p_saccades, 2, n));
end