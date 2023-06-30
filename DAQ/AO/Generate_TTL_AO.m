function Generate_TTL_AO(app)
%
% Generate TTL pulses
%
r = app.recobj;

%%
% Outputsignal is represnted as data point
% Total size is same as recobj.recp
% To que data fro AO, use "preload(d, outputSingla)

delay = zeros( r.sampf * r.TTL.Delay_in_sec, 1);

size_pulseON = round(r.sampf * r.TTL.SinglePulseWidth/1000 * r.TTL.DutyCycle);
pulseON = ones(size_pulseON, 1);

size_pulseOFF = round(r.sampf * r.TTL.SinglePulseWidth/1000 * (1 - r.TTL.DutyCycle));
pulseOFF = zeros(size_pulseOFF, 1);

pulses = repmat([pulseON; pulseOFF], r.TTL.PulseNum, 1);

% off =zeros(r.recp - (length(delay) + length(pulses)),1);
% r.TTL.outputSignal = [delay; pulses; off];
r.TTL.outputSignal = [delay; pulses; zeros(10, 1)];

%% Return
app.recobj = r;
end