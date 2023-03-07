function im = Get_Stim_Tuning(im, s)
%
% Get stimulus specific tuning properties
%
% Appdesigner version 191101
% devide Define_selectivity_DSIS 20220331
%
% BitPlayer version 20230307
%


%%
dFF_peak_p = im.dFF_peak_each_positive;

% Mean peak response
[R_max_p, R_max_stim] = max(mean(dFF_peak_p, 'omitnan'));

% Averaged Maximum peak reponses of all ROI;
im.dFF_max_mean_peak = squeeze(R_max_p);

%Stim# evoking maximum responses
im.R_max_stim = squeeze(R_max_stim);

%% Negative response
% R_max_n = max(mean(-dFF_peak_n, 'omitnan'));
% R_max_n = squeeze(R_max_n);

%%
switch s.Pattern
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    case {'Uni', 'Fine Mapping', 'Looming'}
        % Best stimulus position
        
    case '2P'
        
    case 'Size Random'
        % Best Size (for ON and OFF)
        
    case {'Moving Bar', 'Shifting Grating'}
        % Direction and Orientation
        % -> Get_selectivity_va.m
    case {'Gabor', 'Sinusoidal', 'Moving Spot'}
        % Direction

    case 'Static Bar'
        % Orientation
      
end



end