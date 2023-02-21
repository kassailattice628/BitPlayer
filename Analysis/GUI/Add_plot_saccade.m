function Add_plot_saccade(gui, t_saccades, data_saccades)
%
% Add "*" on the eye traces, using detected saccade data
%

if ~isempty(peaks)
    hold(gui, 'on');
    plot(gui, t_saccades, data_saccades, 'm*');
    hold(gui, 'off');
end
end