function detectTrigger(app)
% Dtects trigger condition and update relevant properties.
% Update TrigActive, TrigMoment, and CapturStartMoment
%
%

%[app.TrigActive, app.TrigMoment] = detectTrigger_main(app.Timestamps, app.Data(:,4));
trigLevel = 3;
condition = app.Data(:,4) > trigLevel;

app.TrigActive = any(condition) & ~all(condition);
app.TrigMoment = []; % trigger timing

if app.TrigActive
        %Find the momoent when trigger condition has been met
    moment_index = 1 + find(diff(condition)==1, 1, 'first');
    app.TrigMoment = app.Timestamps(moment_index);
end


app.CaptureStartMoment = app.TrigMoment;

end



