function Add_plot_saccade(gui, t_saccades, data_saccades)
%
% Add "*" on the eye traces, using detected saccade data
%
hold(gui, 'on')
if ~isempty(peaks)
    plot(gui, t_saccades, data_saccades, 'm*');

end
hold(gui, 'off');


end