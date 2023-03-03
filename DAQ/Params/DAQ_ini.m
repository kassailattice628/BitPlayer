function DAQ_ini(app)
%
% Initialize DAQ interface for BitPlayer
%

%Create a DAQ interface
daqreset;
d_in = daq('ni');
d_in.Rate = app.recobj.sampf;
d_out_ao = daq('ni');
d_out = daq('ni');
%d_in.ScansAvailableFcnCount = app.recobj.recp_live;
%d_in.ScansAvailableFcnCount is 10 times/sec in default.

%% Input Channel Setting

% Dev2: USB-6341(BNC), as triggerd recording
% Add analog input channels (ch1~6)
addinput(d_in, "Dev2", "ai0", "Voltage") %pupil X
addinput(d_in, "Dev2", "ai1", "Voltage") %pupil Y
addinput(d_in, "Dev2", "ai2", "Voltage") %photo sensor
addinput(d_in, "Dev2", "ai3", "Voltage") %trigger monitor
addinput(d_in, "Dev2", "ai4", "Voltage") %pupil size
addinput(d_in, "Dev2", "ai5", "Voltage") %researve

% Add Rotary Encoder (ch7)
addinput(d_in, "Dev2", "ctr0",  "Position");
d_in.Channels(7).EncoderType = "X4";
% Add PTB_serialport connection RTS monitor (ch8)
addinput(d_in, "Dev2", "Port0/Line4", "Digital")

%Range
d_in.Channels(1).Range = [-5, 5];
% d_in.Channels(2).Range = [-5, 5];
% d_in.Channels(3).Range = [-0.2, 0.2];
% d_in.Channels(4).Range = [-5, 5];
% d_in.Channels(5).Range = [-5, 5];
% d_in.Channels(6).Range = [-5, 5];

%% Output Channel Setting

%Add analong output channels
addoutput(d_out_ao, "Dev2", "ao0", "Voltage") 

%DO for TTL trigger for hardware
%%% TTL Condition %%%
% Port0/Line0: DAQ Start (L -> H)
% Port0/Line1: FV Start (L -> H) 
% Port0/Line2: PTB Start (H -> L)
% Port0/Line3: researve
addoutput(d_out, "Dev2", "Port0/Line0:3", "Digital")

%% Reset trigger
write(d_out, [0,0,0,0]);

%% Return app struct
app.d_in = d_in;
app.d_out = d_out;
app.d_out_ao = d_out_ao;
end