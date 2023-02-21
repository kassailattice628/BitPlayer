function [positionDataDeg, rotVel] = Decode_Rotary_Encoder(CTRin, sf)
%
% Transform DAQ counter data (CTRin) from rotary encoder 
% into angular position (deg).
%

signedThreshold = 2^(32-1); % resolution 32 bit

% Wrap
CTRin(CTRin > signedThreshold) =...
    CTRin(CTRin > signedThreshold) - 2^32;

% Transform into degree
positionDataDeg = CTRin * 360 / 1000 / 4;

%
rotor_size = 9; %cm <- 8 cm cylinder <- %12 cm Disk
rotMove = positionDataDeg / 360 * rotor_size;
rotMove = rotMove - rotMove(1); 

% Filter data
d_filt = designfilt('lowpassfir', 'FilterOrder', 8,...
    'CutoffFrequency', 10, 'SampleRate', sf);

rotMove_filt = filtfilt(d_filt, rotMove);

% Velocity
%rotVel = abs(diff(rotMove_filt)/p{1,n}.AIstep);
rotVel = abs(diff(rotMove_filt)*sf);
% Smoothing
rotVel = smooth(rotVel, 10, 'moving');
end