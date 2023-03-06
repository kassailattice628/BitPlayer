function p = Get_ParamsSave(sobj, Blank)

% p for ParamsSave
p.stim1.Blank = Blank;

if ~Blank

    %Stim ON timing
    p.stim1.On_time = sobj.vbl_2 - sobj.vbl_1;
    p.stim1.BeamposON = sobj.BeamposON;

    %Stim OFF timing
    p.stim1.Off_time = sobj.vbl_3 - sobj.vbl_1;
    p.stim1.BeamposOFF = sobj.BeamposOFF;

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

        case 'Fine Mapping'
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

        case '2P'

        case 'B/W'

        case 'Looming'

        case {'Sinusoidal', 'Shifting Grating', 'Gabor'}

            p.stim1.Grating_Angle_deg = sobj.MoveDirection;

        case 'Images'

            p.stim1.Image_index = sobj.img_i;

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