function gui_ini(app)
% initialize GUI info using sobj_ini

app.PatternDropDown.Value = 'Uni';
app.PositionOrderDropDown.Value = 'Random Matrix';
app.ShapeDropDown.Value = 'Circle';

%%
app.Duration.Value = round(app.sobj.Duration_sec);
app.Duration_Label.Text = ['sec = ', num2str(round(app.Duration.Value / app.sobj.MonitorInterval)), ' flips'];

app.Delay.Value = app.sobj.Delay_sec;
app.Delay_Label.Text = ['sec = ', num2str(round(app.Delay.Value / app.sobj.MonitorInterval)), ' flips'];

app.ISI.Value = app.sobj.ISI_sec;

%app.SetBlank.Value = 2;
%app.SetBlank_Label.Txt = ['loops = ' num2str(round(app.SetBlank.Value * )), ' sec'];

app.Size.Value = 1; %Default 1 deg
app.MonitorDiv.Value = app.sobj.DivNum;
app.MonitorDiv_Label.Text = [num2str(app.sobj.DivNum), ' x ', num2str(app.sobj.DivNum), ' Matrix'];

app.FixedPos.Value = app.sobj.FixPos;
app.FixedPos_Label.Text = ['in ', num2str(app.sobj.DivNum), ' x ', num2str(app.sobj.DivNum), ' Matrix'];

app.Direction.Value = app.Direction.Items(1);
app.MoveSpd.Value = app.MoveSpd.Items(2);

app.TemporalFreq.Value = app.TemporalFreq.Items(3);
app.SpatialFreq.Value = app.SpatialFreq.Items(1);
app.LoomingSpd.Value = app.LoomingSpd.Items(1);
app.LoomingMax.Value = app.sobj.LoomingMaxSize;
app.NumImages.Value = app.sobj.ImageNum;
app.MosaicDensity.Value = app.sobj.DotsDensity;
end