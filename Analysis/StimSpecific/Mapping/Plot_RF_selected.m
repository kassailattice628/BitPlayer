function Plot_RF_selected(im, s, roi)
%%%%%%%%%% %%%%%%%%%% %%%%%%%%%
%
% Show color 2D color map 
%
%%%%%%%%%% %%%%%%%%%% %%%%%%%%%%

% Stim poistion
if strcmp(s.Pattern, 'Fine Mapping')% && isfield(s, 'CenterPos_list')
    %Fine map 
    pos = s.Div_grid;

else 
    %Uni
    pos = s.DivNum;
end 

%%
for i = roi
    %Set Color of the selected ROI(i), according to center of the RF.
    
    dFF_peak = mean(im.dFF_peak_each(:,:, i), 'omitnan');

    data = reshape(dFF_peak, pos, pos);
    figure;

    if isfield(im, 'beta_GRot2D')
        tiledlayout(1,2)
        nexttile;
        %plot response with fitted elipse.
        [x_e, y_e] = RF_Elipse(im.beta_GRot2D(i,:));

        imagesc([1, pos], [1, pos], data)
        hold on
        plot(x_e, y_e, 'r', 'LineWidth', 2)
        title(['RF: ROI = ', num2str(i)])
        xlabel("grid"); ylabel("grid")

        nexttile;
        %show fitted image
        x = linspace((1-pos/2), (9+pos/2), 100);
        [X, Y] = meshgrid(x, x);
        XY = [X(:),Y(:)];
        data_fit = GaussianRot2D(im.beta_GRot2D(i,:), XY);
        data_fit = reshape(data_fit, length(x), length(x));
        imagesc([min(x), max(x)], [min(x), max(x)],data_fit);
        xlim([1, pos])
        ylim([1, pos])
        title("Fitted")

    else
        %plot response
        imagesc([1, pos], [1, pos], data)

        title(['RF: ROI = ', num2str(i)])
        xlabel("grid"); ylabel("grid")
    end
    
end 

end