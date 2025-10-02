function Plot_Stim_Tuning_selected(app)
%%%%%%%%%%

im = app.imgobj;
s = app.sobj;

%%%%%%%%%%

stim_list = 1:size(im.dFF_stim_average, 2);
switch s.Pattern
    case {'Uni', 'Fine Mapping'}
        for roi = im.selected_ROIs
            Plot_RF_selected(im, s, roi);
        end
        
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
            Plot_DSOS(im, s, stim, roi)
        end

    case 'Static Bar'
        stim = im.stim_orientations;
        for roi = im.selected_ROIs
            Plot_OS_selected(im, stim, roi)
        end

    case 'ImageNet test'
        
        for ROI = im.selected_ROIs
            figure;
            for i = 1:s.n_Images
                a = im.dFF_peak_each_positive(:,i, ROI);
                b_y=rmmissing(a);
                b_x = repmat(i, length(b_y), 1);
                scatter(b_x, b_y);
                hold on
            end
            hold off
            xlabel("Image #")
            xlim([0, s.n_Images+1])
            ylabel("dFF")
            title(['ROI: ', num2str(ROI)])
        end
end

%%
end