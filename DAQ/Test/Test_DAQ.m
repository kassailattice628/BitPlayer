function [d, data] = Test_DAQ(app)
%Initializing NI DAQ devices
%R2020a or later, session object was deprecated.
app.data_daq =[];
clear plotDataAvailable
%% Initialize DAQ
daqreset;
%dev = daqlist('ni');

%Create a DAQ interface
d = daq('ni');
d.Rate = 5000;
d.ScansAvailableFcnCount = 1000;

%Dev1: USB-6009, as a external trigger source
%Dev2: USB-6341(BNC), as triggerd recording

%Add analog input channels
addinput(d, "Dev2", "ai0", "Voltage") %pupil X
addinput(d, "Dev2", "ai1", "Voltage") %pupil Y
addinput(d, "Dev2", "ai2", "Voltage") %photo sensor
addinput(d, "Dev2", "ai3", "Voltage") %trigger monitor
addinput(d, "Dev2", "ai4", "Voltage") %pupil size
addinput(d, "Dev2", "ai5", "Voltage") %researve

%Rotary Encoder
addinput(d, "Dev2", "ctr0",  "Position");
d.Channels(7).EncoderType = "X4";

%DO for TTL trigger
dout = daq('ni');
addoutput(dout, "Dev2", "Port0/Line0:4", "Digital")
write(dout, [0, 0, 1, 0, 0])

%Port0/Line0: DAQ Start (L -> H)
%Port0/Line1: FV Start (L -> H) 
%Port0/Line2: PTB Start (H -> L)
%Port0/Line3: 

%%
data = [];
d.ScansAvailableFcn = @(src, evt) plotDataAvailable(src, evt, app);
start(d, "Duration", seconds(5))

%%
while d.Running
    pause(1)
    fprintf("While loop: Scans acquired = %d\n", d.NumScansAcquired)
end

fprintf("Acquisition stopped with %d scans acquired\n", d.NumScansAcquired)
end

%% plot data when available.
function plotDataAvailable(src, evt, app)

persistent data_save T

[data, timestamps, ~] = read(src, src.ScansAvailableFcnCount, "OutputFormat", "Matrix");
disp(evt)
data_save = [data_save; data];
T = [T; timestamps];
plot(timestamps, data);

%Update data for save
app.daq_time = T;
app.daq_data = data_save;
end