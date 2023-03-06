function Plot_dFF_selected(app)
%
% Plot dFFs of selected ROIs
%

im = app.imgobj;
s = app.sobj;
n_ROIs = app.imgobj.selected_ROIs;
ax= app.UIAxes_2;



%% dFF
y = im.dFF(:,n_ROIs);
x = im.FVt;

discards = [];

for i = 1:length(n_ROIs)

    if i == 1
        % draw stim timing
        fill(ax, s.stim_area_X, s.stim_area_Y, [0.9, 0.9, 0.9], 'EdgeColor', 'none');
        hold(ax, 'on')
    end
    
    if ~isnan(y(:, 1))
        plot(ax, x, y(:,i), 'Color', [0, 0.35, 1])
    else
        %no data containing
        discards = [discards, i];
    end
end
hold(ax, 'off')

if ~isempty(discards)
    disp(['ROI# ', num2str(discards), ' does not contain data.']);
end



end