function p = Get_ParamsSave(sobj, Blank)

% p for ParamsSave
p.stim1.Blank = Blank;

if ~Blank

    %PTB Timing
    %{
p.vbl_1 = sobj.vbl_1; %flip background (start) 
p.vbl_2 = sobj.vbl_2; %flip stimli (presentation)
p.vbl_3 = sobj.vbl_3; %flip background (end)
    %}
    %Stim ON timing
    p.stim1.On_time = sobj.vbl_2 - sobj.vbl_1;
    p.stim1.BeamposON = sobj.BeamposON;
    %Stim OFF timing
    p.stim1.Off_time = sobj.vbl_3 - sobj.vbl_1;
    p.stim1.BeamposOFF = sobj.BeamposOFF;

    %{
%%% Luminance & Color %%%
%if changable.
p.stim1.Luminance = sobj.stimlumi;
p.stim1.RGB = sobj.stimRGB;
p.stim1.Color = sobj.stimlumi * sobj.stimRGB;
p.stim1.BGColor = sobj.bgcol;
    %}

    %%% Center Position %%%
    switch sobj.Pattern
        case {'Moving Bar'}
        otherwise
            p.stim1.Center_position = sobj.index_center_in_mat;
            p.stim1.CenterX_pix = sobj.StimCenterPos(1);
            p.stim1.CenterY_pix = sobj.StimCenterPos(2);
    end

    %%% Size %%%
    p.stim1.Size_deg = sobj.StimSize_deg;
    p.stim1.SizeX_pix = sobj.StimSize_pix(1);
    p.stim1.SizeY_pix = sobj.StimSize_pix(2);

    %%% Pattern Specific, & trial specific Parameters %%%
    switch sobj.Pattern
        case {'Uni', 'Size Random'}
            %Luminance & Color?

        case {'Fine Mapping'}
            % Fine mapping index
            p.stim1.Center_position_in_FineMapArea = sobj.index_center_in_mat;

            %Luminance & Color?

        case {'Moving Bar'}
            % Mogving direction and speed.
            %p.stim1.Movebar_Spd_deg_per_s = sobj.MoveSpd;
            p.stim1.Movebar_Direction_angle_deg = sobj.MoveDirection;

        case 'Moving Spot'
            %Moving direction and speed.
            %p.stim1.Movespot_Spd_deg_per_sec = sobj.MoveSpd;
            p.stim1.Movespot_Direction_angle_deg = sobj.MoveDirection;

        case 'Static Bar'
            %Orientation, Bar length
            p.stim1.Bar_Orientation_angle_deg = sobj.BarOrientation;
            %bar legnth => sobj.stim_length

        case {'2P'}
            %{
        % concentric_position stim1 or stim 2
        p.stim1.Distance_from_center_deg = sobj.concentric_mat_deg(sobj.conc_index, 1);
        p.stim1.Angle_deg = sobj.concentric_mat_deg(sobj.conc_index, 2);

        if strcmp(pattern, '2P')
            % params for stim2
            % timing
            if get(figUIobj.stim,'value')
                % Stim ON %
                p.stim2.On_time = sobj.vbl2_2 - sobj.vbl_1;
                p.stim2.BeamposON = sobj.BeamposON_2;
                % Stim Off %
                p.stim2.Off_time = sobj.vbl2_3 - sobj.vbl2_2;
                p.stim2.BeamposOFF = sobj.BeamposOFF_2;
            end
            % center position
            p.stim2.centerX_pix = sobj.stim_center2(1);
            p.stim2.centerY_pix = sobj.stim_center2(2);
            % size
            p.stim2.size_deg = sobj.size_deg2;
            p.stim2.sizeX_pix = sobj.stim_size2(1);
            p.stim2.sizeY_pix = sobj.stim_size2(2);
            % color luminace
            p.stim2.lumi = sobj.lumi2;
            p.stim2.color = sobj.stimcol2;
        end
            %}
        case 'B/W'

        case 'Looming'
            % looming speed and maximum size
            %p.stim1.Looming_Spd_deg_per_sec = sobj.LoomingSpd;
            %p.stim1.Looming_MaxSize_deg = sobj.LoomingMaxSize;

        case {'Sinusoidal', 'Shifting Grating', 'Gabor'}
            % Sin, Rect, Gabor, Grating pramas
            %p.stim1.Grating_SF_cycle_per_deg = sobj.SpatialFreq;
            %p.stim1.Grating_Spd_Hz = sobj.TemporalFreq;
            p.stim1.Grating_Angle_deg = sobj.MoveDirection;

        case 'Images'
            % Image
            p.stim1.Image_index = sobj.img_i;
            %{
        if strcmp(mode, 'Concentric')
            p.stim1.Distance_from_center_deg = sobj.concentric_mat_deg(sobj.conc_index, 1);
            p.stim1.Angle_deg = sobj.concentric_mat_deg(sobj.conc_index, 2);
        end
            %}

        case {'Mosaic'}
            % Mosaic Dot pattern
            p.stim1.RandPosition_seed = sobj.def_seed1; % for position
            p.stim1.RandSize_seed = sobj.def_seed2; % for size

            % tentative
            % if the two seeds were enough to reproduce mosaic
            % dots, following prams dose'nt need to be saved.
            p.stim1.Position_deg_mat = sobj.dot_position_deg;
            p.stim1.Size_deg_mat = sobj.dot_sizes_deg;

    end
end
end