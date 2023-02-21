function [velocity] = Get_eye_velocity(data, sf)
%
% Calculate 2D eye velocity
% data: app.SaveData(:, 1;2, n_in_loop)
% sf: app.recobj.sampf

%% % prep data % 

% Offset data
off1 = [];
off2 = [];
data_ = Offset_data(data, []);


% Low pass fiter
d_filt_eye = designfilt('bandpassfir',...
    'FilterOrder', 8,...
    'CutoffFrequency1',10,... %20
    'CutoffFrequency2', 20,... %100
    'SampleRate', sf);     
   
datafilt_ = filtfilt(d_filt_eye, data_);

% Movingaveraged data
datamv_ = movmean(datafilt_, 180);

datamv = Offset_data(datamv_, []);

% Calculate radial velocity speed
data1_diff = diff(datamv(:,1)); %data1filt
data2_diff = diff(datamv(:,2)); %data2filt
[~, r_amp] = cart2pol(data2_diff, -data1_diff);
velocity_pre = r_amp * sf;

% Low-pass velociy
d_filt_vel = designfilt('bandpassfir',...
    'FilterOrder', 8,...
    'CutoffFrequency1', 1,...
    'CutoffFrequency2', 50,...
    'SampleRate', sf);
  
velocity = filtfilt(d_filt_vel, velocity_pre);
velocity = movmean(velocity, 100); 


end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data_out = Offset_data(data_in, offset)

%
% Calculate offsetted data
% if "offset" is specified, the data is offsetted by "offset".
%

for i = 1:size(data_in, 2)
    if isempty(offset)
        offset = data_in(1,i);
    end
    data_out(:,i) = data_in(:,i) - offset;
end

end