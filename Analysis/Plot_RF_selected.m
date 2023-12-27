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

order = 1:pos^2;
order = reshape(order, [], pos);

for i = roi
    %Set Color of the selected ROI(i), according to center of the RF.
    
    dFF_peak = mean(im.dFF_peak_each(:,:, i), 'omitnan');

    data = reshape(dFF_peak, pos, pos);
    figure, imagesc(data)
    
end 

end