function Show_Colormap_allROIs(im)
%
% plot all ROIs 
%

% Set color range
a = reshape(mat, [], 1);
b = prctile(a, 99.5);
%c = prctile(a, 0.5);
clims = [-b, b];

p_data = size(im.dFF_stim_average, 1);
n_stim = im.Num_ROIs;

figure
tiledlayout(2,2);
nexttile([1,2]);
Show_mat(im.mat2D, im.Num_ROIs, n_stim, p_data, clims);

%Sort by tuning
if isfield(im ,'mat2D_sorted')
    tiledlayout(2,2);
    nexttile([1,2]);
    Show_mat(im.mat2D_sprted, im.Num_ROIs, n_stim, p_data, clims);
    title('Sorted by Tuning')
end


end

%%
function Show_mat(mat, n_ROIs, n_stim, p_data, clims)

imagesc(mat, clims)
% img_x = 1:size(im.mat2D, 2);
% T = (img_x - 1)*im.FVsampt;
% imagesc(T, img_x, im.mat2D, clims)

%stim position
stim_y = [0, n_ROIs+1];

xt = [];
for n = 1:n_stim %num stim
    x = p_data * (n-1);
    xt = [xt, x];

    line([x, x], stim_y, 'Color', [0.5, 0.5, 1]);
end
xlabel('Stim #')
ylabel('ROI #')
xticks(xt - p_data/2);
xticklabels({''})
end
