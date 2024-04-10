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
        %plot response with fitted elipse.
        [x_e, y_e] = RF_Elipse(im.beta_GRot2D(i,:));

        imagesc([1, pos], [1, pos], data)
        hold on
        plot(x_e, y_e, 'r', 'LineWidth', 2)
    else
        %plot response
        imagesc([1, pos], [1, pos], data)
    end
    title(['RF: ROI = ', num2str(i)])
    
end 

end