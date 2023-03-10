function [beta, ci, f_select, R, Ja] =...
    Fit_vonMises(data_bootstrp, stim, prefAng, f_vM1, f_vM2)

%
% data_bootstrp: bootstrapped data matrix for a selected ROI
%

opts = optimset('Display','off');

data = reshape(data_bootstrp, 1, []);

stim = repmat(stim, [size(data_bootstrp,1), 1]);
stim = reshape(stim, 1, []);



% Model1: Single peak
beta0 = [1, max(data), prefAng, min(data)];
bl = [0.001, 0.01, 0, 0];
bu = [10, max(data)*2, 2*pi, max(data)];
[b_fit1, res1, ci1, J1, R1] = Exec_Fit(f_vM1, stim, data, beta0, bl, bu, opts);

% Model2: Double peaks (sum of 2 VM)
beta0 = [1, 1, 0, 0, prefAng, wrapTo2Pi(prefAng+pi)];
bl = [0.001, 0.01, 0.01, 0, 0, pi/4];
bu = [10, max(data)*2, max(data)*2, 5, 2*pi, 7*pi/4];
[b_fit2, res2, ci2, J2, R2] = Exec_Fit(f_vM2, stim, data, beta0, bl, bu, opts);


% Select models
% beta, ci, f_select, residual, Ja
if res1 <= res2
    beta = [b_fit1, NaN, NaN];
    ci = [ci1, nan(1,4)];
    f_select = 1;
    Ja = J1;
    R = R1;
else
    beta = b_fit2;
    ci = ci2;
    f_select = 2;
    Ja = J2;
    R = R2;
end
end



%% Run Fitting
function [b_fit, res, ci, J, r] = Exec_Fit(f_vM, stim, data, b0, bl, bu, opts)

[b_fit, res, r, ~,~,~,J] = lsqcurvefit(f_vM, b0, stim, data, bl, bu, opts);
ci = nlparci(b_fit,r,'jacobian',J);
ci = reshape(ci', 1, []);

end


