function gui_ini(app)
%
%
% initialize GUI info using sobj_ini
%
%

%%
% ------------------
% Set DropDown list
% ------------------
app.PatternDropDown.Items =...
    {'Uni', 'Fine Mapping', 'Size Random', 'Looming',...
    'Sinusoidal', 'Shifting Grating', 'Gabor',...
    'Random Dot Motion',...
    'Moving Bar', 'Static Bar', 'Moving Spot',...
    'Images', 'Mosaic'};
%{'2 points', 'Black & White', 'Mouse Cursor'};

app.PositionOrderDropDown.Items =...
    {'Random Matrix', 'Ordered Matrix', 'Fix Repeat', 'Concentric'};

app.ShapeDropDown.Items =...
    {'Circle', 'Square'};

app.Direction.Items =...
    {'0', '45', '90', '135', '180', '225', '270', '315',...
    'Ord8', 'Rand8', 'Ord12', 'Rand12', 'Rand16'};

app.BarOrientation.Items =...
    {'0','30','60','90', '-30', '-60',...
    'Ord6', 'Rand6', 'Rand12'};

app.MoveSpd.Items = {'5', '10', '20', '40'};

app.TemporalFreq.Items = {'0.5', '1', '2', '4', '8'};

app.SpatialFreq.Items = {'0.01', '0.02','0.04','0.08','0.16','0.32'};

app.LoomingSpd.Items = {'5','10','20','40','80'};

app.ConcentricDirection.Items =...
    {'0', '45', '90', '135', '180', '225', '270', '315',...
    'Ord8', 'Rand8', 'Ord12', 'Rand12', 'Rand16'};

app.Coherence.Items = ...
    {'Random', '1%', '10%', '30%', '50%', '70%', '90%', '99%'};


%%
% --------------------
% Set values
% --------------------
app.PatternDropDown.Value = 'Uni';
app.PositionOrderDropDown.Value = 'Random Matrix';
app.ShapeDropDown.Value = 'Circle';

%
app.Duration.Value = round(app.sobj.Duration_sec);
app.Duration_Label.Text =...
    ['sec = ', num2str(round(app.Duration.Value / app.sobj.MonitorInterval)), ' flips'];

app.Delay.Value = app.sobj.Delay_sec;
app.Delay_Label.Text =...
    ['sec = ', num2str(round(app.Delay.Value / app.sobj.MonitorInterval)), ' flips'];

app.ISI.Value = app.sobj.ISI_sec;

app.Blankloop.Value = app.sobj.Blankloop_times;
app.BlankloopLabel.Text = ...
    ['loops, ', num2str((app.Duration.Value + app.ISI.Value)*app.Blankloop.Value), ' sec'];

% Size, Position
app.Size.Value = 1;
app.MonitorDiv.Value = app.sobj.DivNum;
app.MonitorDiv_Label.Text = [num2str(app.sobj.DivNum), ' x ', num2str(app.sobj.DivNum), ' Matrix'];

app.FixedPos.Value = app.sobj.FixPos;
app.FixedPos_Label.Text = ['in ', num2str(app.sobj.DivNum), ' x ', num2str(app.sobj.DivNum), ' Matrix'];

% Direction, Orientation, Speed
app.Direction.Value = app.Direction.Items(1);

app.MoveSpd.Value = app.MoveSpd.Items(2);

app.TemporalFreq.Value = app.TemporalFreq.Items(3);
app.SpatialFreq.Value = app.SpatialFreq.Items(1);

app.BarOrientation.Value = app.BarOrientation.Items(1);

app.LoomingSpd.Value = app.LoomingSpd.Items(1);
app.LoomingMax.Value = app.sobj.LoomingMaxSize;
app.NumImages.Value = app.sobj.ImageNum;
app.DotDensity.Value = app.sobj.DotDensity * 100;

app.Coherence.Value = app.Coherence.Items(1);

app.ConcentricDirection.Value = app.ConcentricDirection.Items(1);
end