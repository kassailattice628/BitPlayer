function [sac_mat1v, sac_mat2v] = Get_peri_saccade_all(D, P, sf)
% D: app.SaveData(:,1:2,:), eye-horizontal + vertical
% P: app.ParamsSave
% sf = app.recobj.sampf

n_trials = size(D, 3);
plot_range_sec = 0.1; % ± 100 ms

sac_mat1v = [];
sac_mat2v = [];
sac_mat1h = [];
sac_mat2h = [];

for i = 1:n_trials
    %i = 5;
    [mat1v, mat2v, mat1h, mat2h] =...
        Get_peri_saccade_single(D(:,1:2, i), P{i}, sf, plot_range_sec);
    sac_mat1v = [sac_mat1v; mat1v];
    sac_mat2v = [sac_mat2v; mat2v];
    sac_mat1h = [sac_mat1h; mat1h];
    sac_mat2h = [sac_mat2h; mat2h];
    %disp(i)
end

%% check
t_plot = -plot_range_sec:1/sf:plot_range_sec;
Plot_peri_saccade(sac_mat1v, sac_mat2v,...
    sac_mat1h, sac_mat2h, t_plot);
