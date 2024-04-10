function [beta_fit, adjustedR2] = Find_RF_fit(data, s)
%
% Using bootstrapped data (data_bstrp), 
% the function of 2D Gaussian with rotation is estimated.
% From fitted parameter, RF center and size (shape) are analyzed.
%
% i_ROI: selected ROI
% data: response data
% for RAW data size of data is (num_trials, num_grids)
% for Bootstrapped data, (num_bootstraps, num_grids)
%

% The number of grid 2D
n_div = sqrt(size(data, 2));

[X, Y] = meshgrid(1:n_div); 
% XYgrids = zeros(n_div, n_div, 2);
% XYgrids(:,:,1) = X;
% XYgrids(:,:,2) = Y;
X = X(:);
Y = Y(:);

% Set a vector for parameter
% b(1): amplitude
% b(2): x0
% b(3): x_SD
% b(4): y0
% b(5): y_SD
% b(6): phi (rotation angle)

data = mean(data, 'omitnan');
d = data';
del = ~isnan(d);

data = d(del);
X = X(del);
Y = Y(del);
XYgrids = [X,Y];

%data = reshape(data, [n_div, n_div]);


%% curve fitting

%upper limt of RF SD
max_sd = 20;
%lower limit of RF SD
min_sd = 1;

if strcmp(s.Pattern, 'Uni')
    grid_deg_x = Pix2Deg(s.RECT(3), s.MonitorDist , s.Pixelpitch);
    grid_deg_y = Pix2Deg(s.RECT(4), s.MonitorDist , s.Pixelpitch);


    u_sd_x = max_sd/gird_deg_x;
    u_sd_y = max_sd/grid_deg_y;

    l_sd_x = min_sd/grid_deg_x;
    l_sd_y = min_sd/grid_deg_y;

elseif strcmp(s.Pattern, 'Fine Mapping')
    % grid size (deg)
    grid_deg = s.Distance/s.Div_grid;
    u_sd_x = max_sd/grid_deg;
    u_sd_y = u_sd_x;

    l_sd_x = min_sd/grid_deg;
    l_sd_y = l_sd_x;
end

% initial parameter
b_0 = [max(data, [], 'all'), 5, 3, 5, 3, 0];

%{
%Use fitnlm rather than lsqcurvfit
% -> upper/lower boundary cannot used in fitnlm
tbl = table(X(:), Y(:), data(:));

mdl = fitnlm(tbl, fun_GaussianRot2D, b_0);
beta_fit = mdl.Coefficients.Estimate;
adjustedR2 = mdl.Rsquared.Adjusted;
%}


% upper/lower boundary
b_upper = [1.5 * max(data, [], 'all'),...
    n_div + u_sd_x, u_sd_x, n_div + u_sd_y, u_sd_y, pi];

b_lower = [0.1, -u_sd_x, l_sd_x, -u_sd_y, l_sd_y, 0];

% option for lsqcurvefit
opts = optimset('Display', 'off');

[beta_fit, res] = lsqcurvefit(@GaussianRot2D,...
    b_0, XYgrids, data, b_lower, b_upper, opts);

SS_total = sum((data(:) - mean(data(:))).^2);
%SS_residual = sum((data(:) - data_predict(:)).^2);
R2 = 1 - res / SS_total;
n = length(data(:));
p = length(beta_fit);
adjustedR2 = 1 - (1-R2)*(n-1) / (n-p-1);



%{
ci = nlparci(beta_fit, r, 'jacobian', J);
ci = reshape(ci', 1, []);
%}

end