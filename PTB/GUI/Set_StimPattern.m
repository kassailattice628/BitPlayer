function Set_StimPattern(app)

EnableOffAll(app);

value = app.PatternDropDown.Value;

switch value
    case {'Uni','Black & White'}
        
        if strcmp(app.PositionOrderDropDown.Value, 'Concentric')
            app.Distance.Enable = 'on';
            app.Divide.Enable = 'on';
            app.ConcentricDirection.Enable = 'on';
            app.ConcentricDirection_Label.Enable = 'on';
        end
        
    case 'Fine Mapping'
        app.GetFinePos.Enable = 'on';
        app.Distance.Enable = 'on';
        app.Divide.Enable = 'on';
        
    case 'Size Random'
        app.Size.Enable = 'off';
        
    case 'Moving Bar'
        app.ShapeDropDown.Enable = 'off';
        app.PositionOrderDropDown.Enable = 'off';
        app.Direction.Enable = 'on';
        app.Direction_Label.Enable = 'on';
        app.MoveSpd.Enable = 'on';
        app.MoveSpd_Label.Enable = 'on';
        app.DurationMoveStim_Label.Enable = 'on';
        app.MoveSpd.Items = {'5', '10', '20', '40'};
        app.MoveSpd.Value = app.MoveSpd.Items(2);
        
    case 'Moving Spot'
        app.Direction.Enable = 'on';
        app.Direction_Label.Enable = 'on';
        app.MoveSpd.Enable = 'on';
        app.MoveSpd_Label.Enable = 'on';
        
        app.Distance.Enable = 'on';
        app.DurationMoveStim_Label.Enable = 'on';
        
    case 'Static Bar'
        app.ShapeDropDown.Enable = 'off';
        app.BarOrientation.Enable = 'on';
        app.BarOrientation_Label.Enable = 'on';

    case 'Mosaic'
        app.DotDensity.Enable = 'on';
        app.DotDensity_Label.Enable = 'on';
        
    case 'Images'
        app.NumImages.Enable = 'on';
        
    case {'Sinusoidal', 'Shifting Grating', 'Gabor'}
        app.SpatialFreq.Enable = 'on';
        app.SpatialFreq_Label.Enable = 'on';
        app.TemporalFreq.Enable = 'on';
        app.TemporalFreq_Label.Enable = 'on';
        app.Direction.Enable = 'on';
        app.Direction_Label.Enable = 'on';
        app.PositionOrderDropDown.Value = 'Fix Repeat';
        
    case {'Looming'}
        app.LoomingMax.Enable = 'on';
        app.LoomingMax_Label.Enable = 'on';
        app.LoomingSpd.Enable = 'on';
        app.LoomingSpd_Label.Enable = 'on';
        app.PositionOrderDropDown.Value = 'Fix Repeat';
        
    case 'Mouse Cursor'
        app.Size.Enable = 'off';
        app.MonitorDiv.Enable = 'off';
        app.FixedPos.Enable = 'off';

    case 'Random Dot Motion'
        app.Direction.Enable = 'on';
        app.Direction_Label.Enable = 'on';
        app.MoveSpd.Enable = 'on';
        app.MoveSpd_Label.Enable = 'on';
        app.Coherence.Enable = 'on';
        app.Distance.Enable = 'on';
        app.Size.Enable = 'off';
        app.Size_Label.Enable = 'off';

        app.Direction.Items =...
            {'0 vs 180', '90 vs 270',...
            '0', '45', '90', '135', '180', '225', '270', '315',...
            'Rand12'};
        app.Direction.Value = app.Direction.Items(1);

        app.MoveSpd.Items = {'1', '3', '5', '10'};
        app.MoveSpd.Value = app.MoveSpd.Items(3);
        
end
end

%% %%%%
function EnableOffAll(app)
%
% All off other than Size, MonitorDiv, Fixed Pos
%
app.DurationMoveStim_Label.Enable = 'off';

app.PositionOrderDropDown.Enable = 'on';
app.ShapeDropDown.Enable = 'on';

app.Size.Enable = 'on';
app.Size_Label.Enable = 'on';
app.MonitorDiv.Enable = 'on';
app.FixedPos.Enable = 'on';

app.Distance.Enable = 'off';
app.Divide.Enable = 'off';

app.DotDensity.Enable = 'off';
app.DotDensity_Label.Enable = 'off';

app.NumImages.Enable = 'off';

app.LoomingMax.Enable = 'off';
app.LoomingMax_Label.Enable = 'off';
app.LoomingSpd.Enable = 'off';
app.LoomingSpd_Label.Enable = 'off';

app.SpatialFreq.Enable = 'off';
app.SpatialFreq_Label.Enable = 'off';
app.TemporalFreq.Enable = 'off';
app.TemporalFreq_Label.Enable = 'off';

app.BarOrientation.Enable = 'off';
app.BarOrientation_Label.Enable = 'off';

app.Direction.Enable = 'off';
app.Direction_Label.Enable = 'off';
app.MoveSpd.Enable = 'off';
app.MoveSpd_Label.Enable = 'off';

app.ConcentricDirection.Enable = 'off';
app.ConcentricDirection_Label.Enable = 'off';

app.GetFinePos.Enable = 'off';

app.Coherence.Enable = 'off';

app.Direction.Items =...
    {'0', '45', '90', '135', '180', '225', '270', '315',...
    'Ord8', 'Rand8', 'Ord12', 'Rand12', 'Rand16', 'Free'};
app.Direction.Value = app.Direction.Items(12);
end