function [p_prestim, p_stim, p_poststim] =...
    Set_length_averaged_timepoint(s, im)
%%%%%%%%%%
%
% Pre stimulus time is 2 sec from stim ON
% Appdesigner version 191101
% BitPlayer version 20230306
%
%%%%%%%%%%

%%
t_prestim = 1.5; %sec

p_prestim = ceil(t_prestim/im.FVsampt); %point


% Stim duration in sec
if strcmp(s.Pattern, 'Moving Bar') ||...
        strcmp(s.Pattern, 'Moving Spot')
    duration = max(s.MovingDuration);
else
    duration = s.Duration_sec;
end


% Duration of post stimulus periods in sec
switch s.Pattern
    case 'Uni'
        d = 2;
    
    case {'Sinusoidal', 'Shifting Grating', 'Gabor'}
        d = 5;

    case 'Fine Mapping'
        d = 3;

    case {'Decode test_v1', 'Decode rand_v1'}
        d = 4;

    otherwise
        d = 5;
end

post_sec = min(d, s.ISI_sec);

%%
p_stim = round(duration/im.FVsampt);
p_poststim = round(post_sec/im.FVsampt);

end