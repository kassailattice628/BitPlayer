function Update_text_detected_saccade(gui, t_saccades)
%
% Update detect saccade text field in the GUI
%

%% Update text GUI
if ~isempty(t_saccades)
    %Saccade detected

    locs_text = cell(length(t_saccades),1);
    str_n = zeros(1,length(t_saccades));
    
    for i = 1:length(t_saccades)
        loc_t = round((t_saccades(i))*1000)/1000;
        locs_text{i} = num2str(loc_t);
        str_n(i) = loc_t;
    end
    str = num2str(str_n);
    gui.Value = str;
else
    gui.Value = '';
end