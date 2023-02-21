function [locations, peaks] = Get_detect_saccade(velocity, sf, th)
% 
% Detect saccade timing.
% t1: start time (t(1, n))
% velocity data
% sf: sampling freq
% th: [threshold_low, theshold_high]
%
% output:
% locations: saccade timing
% peaks: amplitudes of saccade peak.

%%
th_high = th(2);
th_low = th(1);

%%
peak_distance_in_sec = 0.3; %peak distance in sec.

[peaks, locs_in_sec] = findpeaks(velocity, sf,...
    'MinPeakHeight', th_low,...
    'MinPeakDistance', peak_distance_in_sec,...
    'MinPeakWidth', 0.02,...
    'MaxPeakWidth', 0.1);
%locations = locs_in_sec + t1;
% sec -> point
locations = uint16(locs_in_sec * sf);

%% Remove saccades that have too much highe peak.
MaxPeakHeight = th_high;
locations = locations(peaks < MaxPeakHeight);
peaks = peaks(peaks < MaxPeakHeight);

end