function detectTrigger(app)
% Dtects trigger condition and update relevant properties.
% Update TrigActive, TrigMoment, and CapturStartMoment
%
%
trigLevel = 4;
condition = app.DataFIFOBuffer(:,4) > trigLevel;

app.TrigActive = any(condition) & ~all(condition);

% trigger timing
app.TrigMoment = [];

if app.TrigActive
    %Find the momoent when trigger condition has been met
    moment_index = 1 + find(diff(condition)==1, 1, 'first');
    app.TrigMoment = app.TimestampsFIFOBuffer(moment_index);
end


app.CaptureStartMoment = app.TrigMoment;

end



