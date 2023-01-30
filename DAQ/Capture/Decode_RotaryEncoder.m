function positionDataDeg = Decode_RotaryEncoder(CTRin)
% Transform data from rotary encoder (CTRin) into angular position (deg).

signedThreshold = 2^(32-1); %resolution 32 bit
signedData = CTRin; %Data from DAQ
signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^32;
positionDataDeg = signedData * 360/1000/4;

end