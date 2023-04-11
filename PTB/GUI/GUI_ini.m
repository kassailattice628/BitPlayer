function GUI_ini(app)

app.PatternDropDown.Items =...
    {'Uni', 'Fine Mapping', 'Size Random', 'Looming',...
    'Sinusoidal', 'Shifting Grating', 'Gabor',...
    'Random Dot Motion',...
    'Moving Bar', 'Static Bar', 'Moving Spot',...
    '2 points', 'Black & White', 'Images', 'Mosaic','Mouse Cursor'};

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

app.ConcentricDirection =...
    {'0', '45', '90', '135', '180', '225', '270', '315',...
    'Ord8', 'Rand8', 'Ord12', 'Rand12', 'Rand16'};




end