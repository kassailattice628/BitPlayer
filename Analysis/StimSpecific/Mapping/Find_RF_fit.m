function b_GaussianRot2D = Find_RF_fit(data)
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
XYgrids = zeros(n_div, n_div, 2);
XYgrids(:,:,1) = X;
XYgrids(:,:,2) = Y;

% Set a vector for parameter
% b(1): amplitude
% b(2): x0
% b(3): x_SD
% b(4): y0
% b(5): y_SD
% b(6): phi (rotation angle)

data = mean(data, 'omitnan');
data = reshape(data, [n_div, n_div]);
%data = reshape(data, [n_div, n_div, size(data,1)]);

[b_GaussianRot2D, ~, ~] = Exec_FitRF(n_div, XYgrids, data);

end

%%
function [beta_fit, res, ci] = Exec_FitRF(n_div, XYgrids, data)
%
% Execute fit
%
% beta_fit = [amp, x0, xsd, y0, ysd, phi]]
%
%

% initial parameter
b_0 = [max(data, [], 'all'), 5, 3, 5, 3, 0];

% upper/lower boundary
b_upper = [1.5 * max(data, [], 'all'),...
    n_div+10, n_div,...
    n_div+10, n_div, pi];

b_lower = [0.01, -10, 0.5, -10, 0.5, 0];
% option for lsqcurvefit
opts = optimset('Display', 'off');


%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%
[beta_fit, res, r, ~, ~, ~, J] =...
    lsqcurvefit(@GaussianRot2D,...
    b_0, XYgrids, data, b_lower, b_upper, opts);

ci = nlparci(beta_fit, r, 'jacobian', J);
ci = reshape(ci', 1, []);

end