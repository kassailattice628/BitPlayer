function Set_StimPattern(app)

ResetAll(app);

value = app.PatternDropDown.Value;
app.sobj.Stim_valiation_type = 'Fixed';
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
        app.sobj.MoveSpd = str2double(app.MoveSpd.Value);
        app.sobj.MoveSpd_i = find(strcmp(app.MoveSpd.Items, app.MoveSpd.Value));
        Check_Stim_Duration(app);
        
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
        
    case {'Sinusoidal', 'Shifting Grating', 'Gabor'}
        app.SpatialFreq.Enable = 'on';
        app.SpatialFreq_Label.Enable = 'on';
        app.TemporalFreq.Enable = 'on';
        app.TemporalFreq_Label.Enable = 'on';
        app.Direction.Enable = 'on';
        app.Direction_Label.Enable = 'on';
        %app.PositionOrderDropDown.Value = 'Fix Repeat';
        
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
        app.Coherence_Mode.Enable = 'on';
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
        app.sobj.MoveSpd = str2double(app.MoveSpd.Value);
        app.sobj.MoveSpd_i = find(strcmp(app.MoveSpd.Items, app.MoveSpd.Value));

    case 'Search V1_Coarse'
        % Yoshida & Ohki 2019 NatCommun
        app.Direction.Enable = 'on';
        app.Direction_Label.Enable = 'on';
        app.SpatialFreq.Enable = 'on';
        app.SpatialFreq_Label.Enable = 'on';
        app.SpatialFreq.Value = app.SpatialFreq.Items(3); %0.04 cpd
        app.TemporalFreq.Enable = 'on';
        app.TemporalFreq_Label.Enable = 'on';
        app.TemporalFreq.Value = app.TemporalFreq.Items(3); %2Hz
        app.Direction.Enable = 'on';
        app.Direction_Label.Enable = 'on';
        app.Size.Value = 40; %50deg


        app.MonitorDiv.Value = 4;
        app.sobj.DivNum = app.MonitorDiv.Value;
        app.MonitorDiv_Label.Text =...
            [num2str(app.MonitorDiv.Value), 'x',...
            num2str(app.MonitorDiv.Value), ' Matrix'];
        app.FixedPos_Label.Text = ['in ', num2str(app.MonitorDiv.Value),...
            'x', num2str(app.MonitorDiv.Value), ' Matrix'];

        app.Direction.Items = {'Rand12'};
        app.Direction.Value = app.Direction.Items(1);

        app.FixedPos.Value = 1;
        app.sobj.FixPos = app.FixedPos.Value;
        app.FixedPos_Label.Text = ['in ', num2str(app.sobj.DivNum),...
            'x', num2str(app.sobj.DivNum), ' Matrix'];

        app.ShapeDropDown.Value = 'Square';
        app.sobj.Shape = 'FillRect';


    case 'Search V1_Fine'
        % Yoshida & Ohki 2019 NatCommun
        app.Direction.Enable = 'on';
        app.Direction_Label.Enable = 'on';
        app.SpatialFreq.Enable = 'on';
        app.SpatialFreq_Label.Enable = 'on';
        app.SpatialFreq.Value = app.SpatialFreq.Items(3); %0.04 cpd
        app.TemporalFreq.Enable = 'on';
        app.TemporalFreq_Label.Enable = 'on';
        app.TemporalFreq.Value = app.TemporalFreq.Items(3); %2Hz
        app.Direction.Enable = 'on';
        app.Direction_Label.Enable = 'on';
        
        app.Direction.Items = {'Rand12'};
        app.Direction.Value = app.Direction.Items(1);

        app.GetFinePos.Enable = 'on';
        app.Distance.Enable = 'on';
        
        app.MonitorDiv.Value = 4;
        app.sobj.DivNum = app.MonitorDiv.Value;
        app.MonitorDiv_Label.Text =...
            [num2str(app.MonitorDiv.Value), 'x',...
            num2str(app.MonitorDiv.Value), ' Matrix'];
        app.FixedPos_Label.Text = ['in ', num2str(app.MonitorDiv.Value),...
            'x', num2str(app.MonitorDiv.Value), ' Matrix'];

        app.Distance.Value = 40;
        app.sobj.Distance = app.Distance.Value;

        app.Divide.Enable = 'on';
        app.Divide.Value = 4;
        app.sobj.Div_grid = app.Divide.Value;

        app.Size.Value = 20; %20deg

        app.ShapeDropDown.Value = 'Square';
        app.sobj.Shape = 'FillRect';

    case 'Image Presentation'
        % reffered from Yoshida & Ohki 2019 NatCommun
        app.NumImages.Enable = 'off';

        app.Delay.Enable = 'off';
        
        app.ISI.Value = 4;
        app.sobj.ISI_sec = app.ISI.Value;

        app.Size.Value = 20; %20deg

        app.ShapeDropDown.Value = 'Square';
        app.sobj.Shape = 'FillRect';

end
end

%% %%%%
function ResetAll(app)
%
% All off other than Size, MonitorDiv, Fixed Pos
%
app.NumImages.Enable = 'on';
app.Duration.Enable = 'on';
app.Delay.Enable = 'on';
app.ISI.Enable = 'on';

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
app.Coherence_Mode.Enable = 'off';

app.Direction.Items =...
    {'0', '45', '90', '135', '180', '225', '270', '315',...
    'Ord12', 'Rand12', 'Rand16', 'Free', 'Ord12+jump', 'Ord16+jump'};
app.Direction.Value = app.Direction.Items(10);

app.ShapeDropDown.Value = 'Circle';
app.sobj.Shape = 'FillOval';
end