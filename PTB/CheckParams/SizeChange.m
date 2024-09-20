function SizeChange(app, val)
%
% from GUI function "SizeValueChanged"
%

app.Size.Value = val;
stimsz = round(ones(1,2) * Deg2Pix(val, app.sobj.MonitorDist, app.sobj.Pixelpitch));
app.sobj.StimSize_pix = stimsz;
app.sobj.Bar_width_pix = stimsz(1);
app.sobj.StimSize_deg = val;
app.sobj.Bar_width = val;


end