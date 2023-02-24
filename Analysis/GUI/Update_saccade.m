function Update_saccade(app)
%
% Updata saccade
%
%%
p = app.ParamsSave;
n = app.n_in_loop;
t = app.SaveTimestamps;

%% Recaluculate saccade timing
%extract saccade timing (data point)
[p_saccades, ~] = Get_detect_saccade(p{1,n}.eye_velocity, app.recobj.sampf,...
    [app.Threshold_saccade_low.Value, app.Threshold_saccade_high.Value]);
%saccade timing in sec
t_saccades = t(p_saccades, n);

app.ParamsSave{1,n}.p_saccades = p_saccades;
app.ParamsSave{1,n}.t_saccades = t_saccades;

end