function data_bstrp = ...
    Bootstrap_RF(im, shuffle)

%
% Bootstrapped resampling for estimation of RF
% Uni: taken using the entire LCD screen.
% Fine Mapping: taken from limited area of the screen.
%
%

if isfield(im, 'n_bstrp')
    n_bstrp = im.n_bstrp;
else
    n_bstrp = 10;
end

dFF_peak = im.dFF_peak_each_positive;
n_stim = size(dFF_peak, 2);
n_ROIs = im.Num_ROIs;

if nargin == 1
    shuffle = false;
end

%% Resampling
if shuffle
    dFF_peak = Shuffle(dFF_peak);
end

data_bstrp = bootstrp(n_bstrp, @(x) [mean(x, 'omitnan')], dFF_peak);
data_bstrp = reshape(data_bstrp, [n_bstrp, n_stim, n_ROIs]);

