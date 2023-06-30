function CheckDuration(app)
% Calculate TTL stim duration and Check them when the TTL switch is ON.
%
% If the TTL delay + TTL stim duration is longer than the recording time,
% rest DAQ recording time and TTL stim duration.
% recobj.TTL.Delay_in_sec = 0.1; %sec
% recobj.TTL.Duration_in_sec = 0.1; %sec
% recobj.TTL.Freq = 100; %Hz
% recobj.TTL.PulseNum = 10;
% recobj.TTL.DutyCycle = 0.5;
% recobj.TTL.SinglePulseWidth = 1000 * recobj.DutyCycle / recobj.TTL.Freq; %ms
%%

obj = app.recobj.TTL;

if app.TTLSwitch.Value
    %Extract TTL setting from GUI.
    obj.Delay_in_sec = app.TTLDelay.Value/1000; % ms -> sec
    obj.Freq = app.TTLFrequency.Value;
    obj.DutyCycle = app.TTLDutyCycle.Value;
    obj.SinglePulseWidth = 1/obj.Freq * obj.DutyCycle * 1000;% ms

    app.SinglePulseWidthLabel.Text = ['Single Pulse Width (ms): ',...
            num2str(obj.SinglePulseWidth), ' ms'];

    switch app.SetDurationDropDown.Value
        case 'Fix Duration'
            %in msec
            obj.Duration_in_sec = app.TTLDuration.Value/1000; %ms -> sec
            obj.PulseNum = round(obj.Duration_in_sec * obj.Freq);
            app.TTLPulseNum.Value = obj.PulseNum;

        case 'Fix Pulse Number'
            %in msec
            obj.PulseNum = app.TTLPulseNum.Value;
            obj.Duration_in_sec = obj.PulseNum / obj.Freq;
            app.TTLDuration.Value = obj.Duration_in_sec * 1000;
    end

    stim_d = obj.Delay_in_sec + obj.Duration_in_sec;

    %Check Duration in msec
    if stim_d > app.recobj.rect
        errordlg('TTL stim duration is longer than the DAQ recording time!')
        
        obj.Delay_in_sec = 0.1; %sec
        obj.Duration_in_sec = 0.1; %sec
        obj.Freq = 100; %Hz
        obj.PulseNum = 10;
        obj.DutyCycle = 0.5;
        obj.SinglePulseWidth = 1000 * obj.DutyCycle / obj.TTL.Freq; %ms

        app.TTLDelay.Value = obj.Delay_in_sec * 1000;
        app.TTLDuration.Value = obj.Duration_in_sec * 1000;
        app.TTLFrequency.Value = obj.Freq;
        app.TTLPulseNum.Value = obj.PulseNum;
        app.TTLDutyCycle.Value = obj.DutyCycle;
        obj.SinglePulseWidth = 1000 * obj.DutyCycle / obj.TTL.Freq; %ms
        app.SinglePulseWidthLabel.Text = ['Single Pulse Width (ms): '...
            num2str(obj.SinglePulseWidth), ' ms'];

        %recobj.rect = 2*1000; %recording time (ms)
        %app.RecTime.Value = recobj.rect;
        
    end
end

%% Return TTL struct
app.recobj.TTL = obj;

%% Update GUI

end 