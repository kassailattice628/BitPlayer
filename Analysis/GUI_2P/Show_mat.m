function Show_mat(mat, n_ROIs, n_stim, p_data, clims)
%
%
%

% Plot colormap
imagesc(mat, clims)
stim_y = [0, n_ROIs+1];
xt = [];

% Add stim line
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