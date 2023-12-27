function Show_Colormap_allROIs_OS(im)
%
% Plot all ROI for DS and OS
%

% Set color range
a = reshape(im.mat2Dori, [], 1);
b = prctile(a, 99.5);
%c = prctile(a, 0.5);
clims = [-b, b];
clims = [-4, 15]; % same color range with "Show_selected_

p_data = size(im.dFF_stim_average_orientation, 1);
n_stim = size(im.dFF_stim_average_orientation, 2);


%%

figure
tiledlayout(2,2);
nexttile([1,2]);
Show_mat(im.mat2Dori, im.Num_ROIs, n_stim, p_data, clims);

%Sort by tuning
if isfield(im ,'roi_sortOS')
    nexttile([1,2]);
    Show_mat(im.mat2Dori(im.roi_sortOS(1,:),:),...
        im.Num_ROIs, n_stim, p_data, clims);
    title('Sorted by Tuning')
end


end
