function VisStimON(app, n_in_loop)
%%%%%%%%%%
%
% Generate visual stimuli and present in 2nd display.
%
%%%%%%%%%%

% Check parameters & Update GUI...
% display total stim duration in sec

% Presenting Visual Stimuli
sobj = app.sobj;
sobj.n_in_loop = n_in_loop;
disp('on')

switch sobj.Pattern
    case {'Uni'}
        %Stim position
        sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);

        % Blank %%%%%%%%%%%%%%%%%
        [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);
        Prepare_stim_spot(sobj.StimSize_pix);
        [sobj.vbl_2, sobj.BeamposON, sobj.vbl_3, sobj.BeamposOFF] =...
            Stim_spot2(sobj, app.StiminfoTextArea);

    case 'Fine Mapping'
        %Stim position
        FineMapArea_deg = [0, 0, sobj.Dist, sobj.Dist];
        FineMapArea = Deg2Pix(FineMapArea_deg, sobj.MonitorDist, sobj.Pixelpitch);
        
        %Define center of the subarea (fix pos in DivNum^2 matrix)
        Pos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
        C = Pos_list(sobj.FixPos, :);
        
        %Corner position in pix
        AREA = CenterRectOnPointd(FineMapArea, C(1), C(2));
        
        %Define CenterPos_list for fine mapping
        sobj.CenterPos_list = Get_StimCenter_in_matrix(AREA, sobj.Div_grid);
        
        % Blank -> Stim ON -> Stim OFF %%%%%%%%%%%%%%%%%
        [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);
        Prepare_stim_spot(sobj.StimSize_pix);
        [sobj.vbl_2, sobj.BeamposON, sobj.vbl_3, sobj.BeamposOFF] =...
            Stim_spot2(sobj, app.StiminfoTextArea);

    case 'Size Random'
        %Stim position
        sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
        sobj = Set_StimSize_Spot(sobj);
        
        %%%%%%%%%%%%%%%%%%
        [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);
        Prepare_stim_spot(sobj.StimSize_pix);
        [sobj.vbl_2, sobj.BeamposON, sobj.vbl_3, sobj.BeamposOFF] =...
            Stim_spot2(sobj, app.StiminfoTextArea);

    case 'Moving Bar'
        %Moving direction
        sobj = Set_Direction(app.Direction.Value, sobj);
        [dist, duration] = Set_MovingDuration(sobj);

        flipnum = round(duration/sobj.MonitorInterval);
        
        %%Prepare Bar
        [im_tex, ~, tex_pos] = Make_BarTexture(dist, flipnum, sobj);
        
        % Prep Fist flip %%%%%%%%%%%%%%%%%
        [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);
        Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
        Screen('DrawTexture', sobj.wPtr, im_tex, [], tex_pos(1,:), -sobj.MoveDirection)
        
        %First flip
        [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
            Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
        vbl = sobj.vbl_2;
        ShowStimInfo(sobj, app.StiminfoTextArea);
        drawnow;

        %Mvoing flips
        for i = 2:flipnum
            Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
            Screen('DrawTexture', sobj.wPtr, im_tex, [], tex_pos(i,:), -sobj.MoveDirection);
            %Flip
            vbl = Screen('Flip', sobj.wPtr, vbl + (sobj.MonitorInterval/2));
        end

        %Stim OFF
        sobj = MovingStim_off(sobj, app.StiminfoTextArea, vbl);
        
    case 'Moving Spot'
        %Stim position
        sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
        sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);
        
        %Moving direction
        sobj = Set_Direction(app.Direction.Value, sobj);
        [distance, duration] = Set_MovingDuration(sobj);
        flipnum = round(duration/sobj.MonitorInterval);
        Spot_position = Make_MoveSpot(distance, flipnum, sobj);
        
        %%Draw
        %prepare 1st %%%%%%%%%%%%%%%%%
        [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);
        Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
        Screen(sobj.Shape, sobj.wPtr, sobj.stimlumi, Spot_position(1,:));
        
        %First flip
        [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
            Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
        vbl = sobj.vbl_2;
        ShowStimInfo(sobj, app.StiminfoTextArea);
        drawnow;
        
        %Mvoing flips
        for i = 2:flipnum
            Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
            Screen(sobj.Shape, sobj.wPtr, sobj.stimlumi, Spot_position(i,:));
            %Flip
            vbl = Screen('Flip', sobj.wPtr, vbl + (sobj.MonitorInterval/2));
        end
        
        %Stim OFF
        sobj = MovingStim_off(sobj, app.StiminfoTextArea, vbl);
        
        
    case 'Static Bar'
        %Bar Orientation
        sobj = Set_Orientation(app.BarOrientation.Value, sobj);

        %Stim position
        sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
        sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);

        %Bar length is same as the vertical size of the display
        bar_h = sobj.RECT(4);
        bar_w = sobj.StimSize_pix(1);
        tex_pos = [sobj.StimCenterPos(1) - bar_w/2, sobj.StimCenterPos(2) - bar_h/2,...
            sobj.StimCenterPos(1) + bar_w/2, sobj.StimCenterPos(2) + bar_h/2];

        %%%%%%%%%%%%%%%%%%
        [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

        %Prepare Bar
        [im_tex] = Make_BarOrientationTexture(sobj);
        Screen('DrawTexture', sobj.wPtr, im_tex, [], tex_pos, - sobj.BarOrientation);
        [sobj.vbl_2, sobj.BeamposON, sobj.vbl_3, sobj.BeamposOFF] =...
            Stim_spot2(sobj, app.StiminfoTextArea);

    case 'Looming'
        %Stim position
        sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
        sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);
        
        flipnum = round(sobj.MovingDuration/sobj.MonitorInterval);
        Spot_i = Make_LoomingSpot(flipnum, sobj);

        %prepare 1st %%%%%%%%%%%%%%%%%
        [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);
        Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
         
        %First flip
        Screen(sobj.Shape, sobj.wPtr, sobj.stimlumi, Spot_i(1,:));
        [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
            Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
        vbl = sobj.vbl_2;
        ShowStimInfo(sobj, app.StiminfoTextArea);
        drawnow;
        
        %Mvoing flips
        for i = 2:flipnum
            Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
            Screen(sobj.Shape, sobj.wPtr, sobj.stimlumi, Spot_i(i,:));
            %Flip
            vbl = Screen('Flip', sobj.wPtr, vbl + (sobj.MonitorInterval/2));
        end
        
        %Stim OFF
        sobj = MovingStim_off(sobj, app.StiminfoTextArea, vbl);
        

        
    case {'Sinusoidal', 'Shifting Grating'}
        %Moving Direction
        sobj = Set_Direction(app.Direction.Value, sobj);
        angle = 180 - sobj.MoveDirection;

        %Position of the stimulus
        sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
        sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);

        %Base Stimulus
        base_stimRect = [0, 0, sobj.StimSize_pix(1), sobj.StimSize_pix(2)];
        stimRect = CenterRectOnPointd(base_stimRect,...
            sobj.StimCenterPos(1), sobj.StimCenterPos(2));

        cycles_per_pix = CPD2CPP(sobj.SpatialFreq, sobj.MonitorDist, sobj.Pixelpitch);

        %Generate Grating texture;
        gratingtex = Make_GratingTexture(app);

        %Prep Delay %%%%%%%%%%%%%%%%%
        [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

        %1st frame, phase=0
        Screen('DrawTexture', sobj.wPtr, gratingtex, [], stimRect, angle,...
                [], [], [], [], [], [0, cycles_per_pix, sobj.GratingContrast, 0]);
        
        [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
            Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
        vbl = sobj.vbl_2;
        ShowStimInfo(sobj, app.StiminfoTextArea);
        drawnow;

        %Grating stimuli 
        for count = 1:sobj.FlipNum-1
            phase = count * 360/sobj.FrameRate * sobj.TemporalFreq;
            Screen('DrawTexture', sobj.wPtr, gratingtex, [], stimRect, angle,...
                [], [], [], [], [], [phase, cycles_per_pix, sobj.GratingContrast, 0]);

            %Add Photo Sensor (Left, Bottom)
            Screen('FillRect', sobj.wPtr, 255, [0 sobj.RECT(4)-30, 30, sobj.RECT(4)]);
            vbl = Screen('Flip', sobj.wPtr, vbl + (sobj.MonitorInterval/2));
        end
        
        %Stim OFF
        sobj = MovingStim_off(sobj, app.StiminfoTextArea, vbl);
        

    case 'Gabor'
        %sigma value in the exponential function;
        %sc = sobj.StimSize_pix(1) * 0.16; %what is 0.16??
        sigma = sobj.StimSize_pix(1) /6;
        contrast = 100;


        %Moving Direction
        sobj = Set_Direction(app.Direction.Value, sobj);
        angle = sobj.MoveDirection - 180;

        %Position of the stimulus
        sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
        sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);

        %Base Stimulus
        base_stimRect = [0, 0, sobj.StimSize_pix(1), sobj.StimSize_pix(2)];
        stimRect = CenterRectOnPointd(base_stimRect,...
            sobj.StimCenterPos(1), sobj.StimCenterPos(2));

        cycles_per_pix = CPD2CPP(sobj.SpatialFreq, sobj.MonitorDist, sobj.Pixelpitch);

        %Generate Grating texture;
        gratingtex = Make_GratingTexture(app);

        %Prep Delay %%%%%%%%%%%%%%%%%
        [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

        %1st frame, phase=0
        Screen('DrawTexture', sobj.wPtr, gratingtex, [], stimRect,...
                    angle, [], [], [], [], kPsychDontDoRotation,...
                    [0, cycles_per_pix, sigma, contrast, 1, 0, 0, 0]);
%         Screen('DrawTexture', win, gabortex, [], [],...
%             90+tilt, [], [], [], [], kPsychDontDoRotation,...
%             [phase+180, freq, sc, contrast, aspectratio, 0, 0, 0]);


        [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
            Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
        vbl = sobj.vbl_2;
        ShowStimInfo(sobj, app.StiminfoTextArea);
        drawnow;

        %Grating stimuli 
        for count = 1:sobj.FlipNum-1
            phase = count * 360/sobj.FrameRate * sobj.TemporalFreq;
            Screen('DrawTexture', sobj.wPtr, gratingtex, [], stimRect,...
                    angle, [], [], [], [], kPsychDontDoRotation,...
                    [phase, cycles_per_pix, sigma, contrast, 1, 0, 0, 0]);

            %Add Photo Sensor (Left, Bottom)
            Screen('FillRect', sobj.wPtr, 255, [0 sobj.RECT(4)-30, 30, sobj.RECT(4)]);
            vbl = Screen('Flip', sobj.wPtr, vbl + (sobj.MonitorInterval/2));
        end
        
        %Stim OFF
        sobj = MovingStim_off(sobj, app.StiminfoTextArea, vbl);


    case 'Images'
        %Stim position
        sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
        sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);
        %Set Image
        %Randomize image order
        
    case 'Mosaic'
        %Stim position
        sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
        sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);

    case 'Mouse Cursor'
end

%Return
app.sobj = sobj;

%setRTS(app.SerPort , false) %TTL low -> daq

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Prepare_stim_spot(Size)

        sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);

        maxDiameter = round(max(Size) * 1.5);

        Rect = CenterRectOnPointd([0, 0, Size(1), Size(2)], ...
            sobj.StimCenterPos(1), sobj.StimCenterPos(2));
        
        % Luminance or color
        %%%%% add code %%%%%
        
        % Prepare Screen
        Screen(sobj.Shape, sobj.wPtr, sobj.stimColor, Rect, maxDiameter);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end