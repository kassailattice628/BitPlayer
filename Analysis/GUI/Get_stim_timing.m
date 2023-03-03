function [t_on, t_off] = Get_stim_timing(t, data, n, p, th)
%
% Calculate stimulus timing
% by threshold (from GUI)
% 
% Input:
% p = app.ParamsSave;
% t = app.SaveTimestamps;
% data = app.SaveData;
% th = app.Threshold_photo_sensor.Value;
%
% Output: [stim on in sec, stim off in sec];
%%

i_stim_on = find(data(:, 3, n) > th, 1);
i_stim_off = find(data(:, 3, n) > th, 1, 'last');

if ~isempty(i_stim_on) && ~isempty(i_stim_off)
    t_on = t(i_stim_on, n);
    t_off = t(i_stim_off, n);
    
else
    if ~isfield(p{1,n}.stim1, 'On_time')
        % in Blank Loops
        t_on = [];
        t_off = [];
    else
        t_on = t(1, n) + p{1,n}.stim1.On_time;
        t_off = t(1, n) + p{1,n}.stim1.Off_time;
    end
end

end