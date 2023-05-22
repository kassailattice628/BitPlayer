function Show_selected_response(app)
%
%
%
im = app.imgobj;

for i = im.selected_ROIs
    Y = im.dFF_stim_average(:,:,i);
    T = (0:size(Y,1)-1)*im.FVsampt;

    %stim onset
    on = im.p_prestim + 1;
    %stim onset
    off = im.p_prestim + im.p_stim + 1;
    
    figure
    tiledlayout(2,2);

    %% Stacked dF/F traces
    nexttile([2,1])
    hold on
    for i2 = 1:size(Y,2)
        Y(:,i2) = Y(:,i2) + (i2-1)*2*im.SD(:,i);
        plot(T, Y(:,i2), 'b-')
    end
    line([T(on), T(on)], [min(Y(:,1)), max(Y(:,i2))*1.1], 'Color', 'r', 'LineWidth', 1)
    line([T(off), T(off)], [min(Y(:,1)),max(Y(:,i2))*1.1], 'Color', 'r', 'LineWidth', 1)
    hold off
    title(['ROI# ', num2str(i)])
    xlabel('Time (s)')
    xlim([T(1), T(end)])
    ylabel('dF/F, Stim#')
    %ylim([min(Y(:,1), 'omitnan'), max(Y(:,i2), 'omitnan')*1.1])


    %% Color map
    nexttile([2, 1])
    Y = im.dFF_stim_average(:,:,i);
    img_x = 1:size(Y, 2);

    imagesc(T, img_x, Y')
    if app.Zscore.Value
        clim([-4, 15]);
    else
        clim([-1, 5]);
    end

    line([T(on), T(on)], [0, size(Y,2)+0.5], 'Color', 'w', 'LineWidth', 1)
    line([T(off), T(off)], [0, size(Y,2)+0.5], 'Color', 'w', 'LineWidth', 1)

    ylabel('Stim#')
    xlabel('Time (s)')
    axis xy % Up-side down image.

end