function Show_selected_response(app)
%
%
%
im = app.imgobj;

for i = im.selected_ROIs
    y = im.dFF_stim_average(:,:,i);
    T = (0:size(y,1)-1)*im.FVsampt;
    
    figure
    tiledlayout(2,2);

    % Stacked dF/F traces
    nexttile([2,1])
    hold on
    for i2 = 1:size(y,2)
        y(:,i2) = y(:,i2) + (i2-1)*2*im.SD(:,i);
        plot(T, y(:,i2), 'b-')
    end
    hold off
    title(['ROI# ', num2str(i)])
    xlabel('time (s)')
    xlim([T(1), T(end)])
    ylabel('dF/F')

    % Color map
    nexttile([2, 1])
    imagesc(im.dFF_stim_average(:,:,i)')
    axis xy

end