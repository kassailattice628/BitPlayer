function [t_on, t_off] = Plot_photo_sensor(app, n)

p = app.ParamsSave;
t = app.SaveTimestamps;
data = app.SaveData;
th = app.Threshold_photo_sensor.Value;
ax = app.UIAxes_5;

if ~isempty(app.sobj)
    s = app.sobj;
    
    %%
    if ~isfield(s, 'Blankloop')
        s.Blankloop = 0;
    end
    
    if n > s.Blankloop
        % May have photo sensor signals
        % Detect crossing points (ON, OFF), when visial stim is ON.
        
        [t_on, t_off] = Get_stim_timing(t, data, n, p, th);
        
        
        % Photo sensor
        Set_plot(ax, t(:, n), data(:, 3, n), [t_on, t_off]);
        % Add plot sensor lines.
        hold(ax, 'on');
        % stim line
        line(ax, [t_on, t_on], [ax.YLim(1), ax.YLim(2)], 'Color', "#4DBEEE");
        line(ax, [t_off, t_off], [ax.YLim(1), ax.YLim(2)], 'Color', "#4DBEEE");
        
        % threshold line
        line(ax, [t(1), t(end)],[th, th],'Color', 'c');
        hold(ax, 'off');
        
        ax.XTick = round(linspace(t(1,n), t(end,n), 5), 2);
    else
        
        % Prestimulus condition
        t_on = [];
        t_off = [];
        Set_plot(ax, t(:, n), data(:, 3, n), [t_on, t_off]);
    end

else
    % if sobj is not used. Plot sensor data only.
    t_on = [];
    t_off = [];
    
    Set_plot(ax, t(:, n), data(:, 3, n), [t_on, t_off]);
end

end