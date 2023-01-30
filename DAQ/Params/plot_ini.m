function plot_ini(app)
%
% Generate plot target
%
len = app.recobj.recp;

%% plot %%
x = 1: len;
y1 = zeros([len, 1]);
app.plot1 = plot(app.PupilCenterXY, x, y1, x, y1, '-');
% access %
% app.plot1(1).Xdata, Ydata; app.plot1(2).Xdata, Ydata
app.plot2 = plot(app.PhotoSensor, x, y1, '-');
app.plot3 = plot(app.RotaryEncoder, x, y1, '-');

app.plot5 = plot(app.TriggerMonitor, x, y1, '-');

%% captured plot %%
app.plot4 = plot(app.PlotRecorded, x, y1, x, y1, '-');
end