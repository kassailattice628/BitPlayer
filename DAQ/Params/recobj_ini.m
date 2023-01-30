function recobj_ini(app)
%% recording parameters 
recobj.interval = 1; %loop interval (sec)

recobj.sampf = 5000; %sampling rate (Hz)

recobj.rect = 2*1000; %recording time (ms)

recobj.recp = recobj.sampf * recobj.rect/1000;


%% TTL pulse stimulation by Analog Output?
recobj.TTL.Delay_in_sec = 0.1; %sec
recobj.TTL.Duration_in_sec = 0.1; %sec
recobj.TTL.Freq = 100; %Hz

pulsenum =  round(recobj.TTL.Duration_in_sec * recobj.TTL.Freq);
recobj.TTL.PulseNum = pulsenum;
recobj.TTL.DutyCycle = 0.5;
recobj.TTL.SinglePulseWidth = 1000 * recobj.TTL.DutyCycle / recobj.TTL.Freq; %ms

%% Update GUI
app.ITI.Value = recobj.interval;
app.SamplingRate.Value = recobj.sampf/1000;
app.RecTime.Value = recobj.rect;

app.TTLPulseNum.Value = pulsenum;
app.SinglePulseWidthLabel.Text = ['Single Pulse Width (ms): '...
                num2str(recobj.TTL.SinglePulseWidth), ' ms'];

%% Return
app.recobj = recobj;

end





