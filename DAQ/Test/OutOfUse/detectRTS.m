function RTSDetected = detectRTS(Data_RTS, app, flag)
% not use now 20230125
% input: Data_RTS, app
%

if app.StandAloneModeButton.Value
    RTSDetected = true;

else
    if flag == 1
        % Find RTS from PTB
        trigLevel = 3; % (V) RTS true = TTL Low, RTS false = TTL High

        % Check RTS level LOW
        condition = Data_RTS > trigLevel;
        RTSDetected = any(condition);
    
    elseif flag == 2
        data =  read(Data_RTS);
        RTSDetected = data.("Dev2_port0/line4");
    end
end
end