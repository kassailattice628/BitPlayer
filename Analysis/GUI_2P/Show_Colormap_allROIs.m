function Show_Colormap_allROIs(im)
%
% plot all ROIs 
%


% Set color range
a = reshape(im.mat2D, [], 1);
b = prctile(a, 99.5);
%c = prctile(a, 0.5);
clims = [-b, b];

p_data = size(im.dFF_stim_average, 1);
n_stim = size(im.dFF_stim_average, 2);

%%

figure
tiledlayout(3,2);
nexttile([1,2]);
Show_mat(im.mat2D, im.Num_ROIs, n_stim, p_data, clims);

%Sort by tuning
if isfield(im ,'roi_sortDS')
    nexttile([1,2]);
    Show_mat(im.mat2D(im.roi_sortDS(1, :),:),...
        im.Num_ROIs, n_stim, p_data, clims);
    title('Sorted by Tuning')

    nexttile([1,2]);
    Show_mat(im.mat2D(im.roi_sortDS(2, :),:),...
        im.Num_ROIs, n_stim, p_data, clims);
    title('Sorted by Tuning (Negative first)')
end


end


