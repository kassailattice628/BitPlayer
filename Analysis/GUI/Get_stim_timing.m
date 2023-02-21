function [ON, OFF] = Get_stim_timing(app)
%
% Correct Visual Stimulus timing by Photo sensor signal
% and Thoreshold (GUI).
%
n = app.n_in_loop;

if ~isempty(app.sobj)
    s = app.sobj;
    p = app.ParamsSave;
    th = app.Threshold_photo_sensor.Value;
    t = app.SaveTimestamps;
end

%%
if ~isfield(s, 'Blankloop')
    s.Blankloop = 0;
end

%%
if n > s.Blankloop
    % May have photo sensor signals
    % Detect crossing points (ON, OFF), when visial stim is ON.
    
    i_stim_on = find(app.SaveData(:, 3, n) > th, 1);
    i_stim_off = find(app.SaveData(:, 3, n) > th, 1, 'last');
    
    if ~isempty(i_stim_on) && ~isempty(i_stim_off)
        t_on = app.SaveTimestamps(i_stim_on, n);
        t_off = app.SaveTimestamps(i_stim_off, n);
        
        if ~isfield(p{1,n}.stim1, 'correct_StimON_timing')
            %Do I need to update corON/OFF_
        end
    else
        t_on = app.SaveTimestamps(1, n) + p{1,n}.stim1.On_time;
        t_off = app.SaveTimestamps(1, n) + p{1,n}.stim1.Off_time;
    end
    

    %% Photo sensor
    Set_plot(app.UIAxes_5, t(:, n), app.SaveData(:, 3, n), [t_on, t_off]);
    % Add plot sensor lines.
    th = app.Threshold_photo_sensor.Value;
    Plot_photo_sensor(app.UIAxes_5, th, t_on, t_off, t(:, n));

else
    t_on = [];
    t_off = [];
    
    Set_plot(app.UIAxes_5, t(:, n), app.SaveData(:, 3, n), [t_on, t_off]);
end

%% Return
ON = t_on;
OFF = t_off;

end