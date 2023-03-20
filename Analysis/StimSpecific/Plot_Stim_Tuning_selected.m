function Plot_Stim_Tuning_selected(app)
%%%%%%%%%%

im = app.imgobj;
s = app.sobj;

%%%%%%%%%%

stim_list = 1:size(im.dFF_stim_average, 2);
switch s.Pattern
    case {'Uni', 'Fine Mapping'}
        
        Plot_RF_selected(app, im.selectROI);
        
        
    case 'Size Random'
        %%%%%%%%%%
        if length(stim_list) == 5
            set(gca, 'xticklabel', {'0.5deg', '1deg', '3deg', '5deg', '10deg'});
        elseif length(stim_list) ==  6
            set(gca, 'xticklabel', {'0.5deg', '1deg', '3deg', '5deg', '10deg', '20deg'});
        elseif length(stim_list) == 7
            set(gca, 'xticklabel', {'0.5deg', '1deg', '3deg', '5deg', '10deg', '30deg', '50deg'});
        end
        %%%%%%%%%%
        
        for i = im.selected_ROIs
            figure
            plot(stim_list, im.R_size(:, i, 1), 'bo-', 'LineWidth', 2);
            hold on
            plot(stim_list, im.R_size(:, i, 2), 'ro-', 'LineWidth', 2);
            hold on
            plot(stim_list, im.R_size(:, i, 3), 'k*--')
            set(gca, 'xtick', stim_list)
            
            legend({'ON', 'OFF', 'ALL'})
        end
        
        
    case {'Sinusoidal', 'Shifting Grating', 'Gabor', 'Moving Bar', 'Moving Spot'}
        stim = im.stim_directions;

        for roi = im.selected_ROIs
            Plot_DSOS(im, stim, roi)
        end

    case ''

    case 'Static Bar'
        stim = im.stim_orientations;
        for roi = im.selected_ROIs
            Plot_OS_selected(im, stim, roi)
        end
end

%%
end