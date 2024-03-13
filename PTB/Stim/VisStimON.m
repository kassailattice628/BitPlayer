function VisStimON(app, n_in_loop, n_blankloop)
%%%%%%%%%%
%
% Generate visual stimuli and present in 2nd display.
% Add blank loop 2023/02/16
%
%%%%%%%%%%
%%
% Check parameters & Update GUI...
% display total stim duration in sec

sobj = app.sobj;
sobj.n_in_loop = n_in_loop;

switch sobj.Shape
    case 'FillRect'
        dot_type = 4;
    case 'FillOval'
        dot_type= 2;
end

HideCursor; % Hide the mouse cursor

%% Presenting Visual Stimuli
if n_blankloop > app.Blankloop.Value
    disp('Vis Stim ON')

    switch sobj.Pattern
        case 'Uni'
            %Stim position
            sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);

            % Blank %%%%%%%%%%%%%%%%%
            [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);
            Prepare_stim_spot(sobj.StimSize_pix);
            [sobj.vbl_2, sobj.BeamposON, sobj.vbl_3, sobj.BeamposOFF] =...
                Stim_spot2(sobj, app.StiminfoTextArea);

        case 'Fine Mapping'
            %Stim position
            FineMapArea_deg = [0, 0, sobj.Distance, sobj.Distance];
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

        case 'Fine Mapping Free'
            %%% Stim position (Circular Area: Diameter of sobj.Distance)
            % Randomley sample from the circular area
            d = Deg2Pix(sobj.Distance, sobj.MonitorDist, sobj.Pixelpitch);
            xy = rand(1,2)*d;

            %Define center of the subarea (fix pos in DivNum^2 matrix)
            Pos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
            C = Pos_list(sobj.FixPos, :);

            sobj.StimCenterPos(1) = C(1) + round(xy(1) - d/2);
            sobj.StimCenterPos(2) = C(2) + round(xy(2) - d/2);

            % Blank -> Stim ON -> Stim OFF %%%%%%%%%%%%%%%%%
            [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

            Screen('DrawDots', sobj.wPtr,...
                [sobj.StimCenterPos(1), sobj.StimCenterPos(2)],...
                sobj.StimSize_pix(1), sobj.stimColor,...
                [], dot_type);

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

            %Bar width and height in deg;
            sobj.bar_height = 65; %fixed height
            sobj.bar_witdh = sobj.StimSize_deg(1);

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
            ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);
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
            ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);
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
            %bar_h = sobj.RECT(4);
            bar_h = Deg2Pix(65, sobj.MonitorDist, sobj.Pixelpitch); %Fixed to 65deg
            bar_h = round(bar_h);
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
            ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);
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
            [gratingtex, sobj] = Make_GratingTexture(sobj);

            %Prep Delay %%%%%%%%%%%%%%%%%
            [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

            %1st frame, phase=0
            Screen('DrawTexture', sobj.wPtr, gratingtex, [], stimRect, angle,...
                [], [], [], [], [], [0, cycles_per_pix, sobj.GratingContrast, 0]);

            [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
                Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
            vbl = sobj.vbl_2;
            ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);
            drawnow;

            %Grating stimuli
            for count = 2:sobj.FlipNum
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
            %
            % Gabor contrast is not correct
            % need to be fixed.
            %

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
            gratingtex = Make_GratingTexture(app.sobj);

            %Prep Delay %%%%%%%%%%%%%%%%%
            [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

            %1st frame, phase=0
            Screen('DrawTexture', sobj.wPtr, gratingtex, [], stimRect,...
                angle, [], [], [], [], kPsychDontDoRotation,...
                [0, cycles_per_pix, sigma, contrast, 1, 0, 0, 0]);


            [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
                Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
            vbl = sobj.vbl_2;
            ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);
            drawnow;

            %Grating stimuli
            for count = 2:sobj.FlipNum
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


        case 'Image Presentation'
            %Stim position
            sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
            sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);

            % Delay %
            % Prepare blank while delay period
            Screen('FillRect', sobj.wPtr, sobj.bgcol);
            [sobj.vbl_1, sobj.onset, sobj.flipend]= Screen('Flip', sobj.wPtr);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Prepare stimulation (1st)
            % Indicator for photo sensor at left bottom of the Monitor
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Photosensor
            Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
            % Select image and make texture

            % Define location of images
            img_dir = fullfile('Images', 'doi_test');
            img_ext = '.jpg';
            [sobj, imgtex, stimRect] = ...
                Set_ImagePresentation(sobj, img_dir, img_ext);
            Screen('DrawTexture', sobj.wPtr, imgtex, [], stimRect);

            % Stim ON (after 200ms delay)
            [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
                Screen('Flip', sobj.wPtr, sobj.vbl_1 + 0.2);
            ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value)

            vbl = sobj.vbl_2;
            for n = 1:2
                %Prepare blank full screen
                Screen('FillRect', sobj.wPtr, sobj.bgcol);
                vbl = Screen('Flip', sobj.wPtr, vbl + 0.2);

                %Prepare next stim + photosensor
                Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
                Screen('DrawTexture', sobj.wPtr, imgtex, [], stimRect);
                vbl = Screen('Flip', sobj.wPtr, vbl + 0.2);
            end

            % Off
            %Prepare blank full screen
            Screen('FillRect', sobj.wPtr, sobj.bgcol);

            %Flip (Stim OFF)
            [sobj.vbl_3, ~, ~, ~, sobj.BeamposOFF] = ...
                Screen('Flip', sobj.wPtr, vbl + 0.2);
            ResetStimInfo(app.StiminfoTextArea);

        case 'Random Dot Motion'
            %Stim center position
            sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
            sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);

            %Moving Direction
            sobj = Set_Direction(app.Direction.Value, sobj);

            %Coherence
            sobj = Set_Coherence(app.Coherence, app.Coherence_Mode.Text,...
                sobj);

            % Stim ON
            sobj = RandomDotMotion(sobj, app.StiminfoTextArea);

        case 'Search V1_Coarse'
            % Define position of the stimulus
            sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
            sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);

            % Stim ON
            sobj = Sinusoidal_and_Grating(app.Direction.Value,...
                sobj, app.StiminfoTextArea);


        case 'Search V1_Fine'

            %Stim position
            FineMapArea_deg = [0, 0, sobj.Distance, sobj.Distance];
            FineMapArea = Deg2Pix(FineMapArea_deg, sobj.MonitorDist, sobj.Pixelpitch);

            %Define center of the subarea (fix pos in DivNum^2 matrix)
            Pos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
            C = Pos_list(sobj.FixPos, :);

            %Corner position in pix
            AREA = CenterRectOnPointd(FineMapArea, C(1), C(2));

            %Define CenterPos_list for fine mapping
            sobj.CenterPos_list = Get_StimCenter_in_matrix(AREA, sobj.Div_grid);
            sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);

            % Stim ON
            sobj = Sinusoidal_and_Grating(app.Direction.Value,...
                sobj, app.StiminfoTextArea);

        case 'Decode SC_v1'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Monochromic dot pattern 16*16 or 32*32
            %
            % Stim size:    60 deg (850pix, monitor dist:200mm)
            % Dot size:     1.875 deg for 32*32 tiles
            %               3.75 deg for 16*16 tiles
            %
            % This stim is used for SC Decording with Kamitani Lab.
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            %sobj.Checker_RECT = Set_RandChecker(app);
            % @Set_StimPattern.m

            %Randomize Checker Pattern (1:white; 0:black)
            sobj.checker_pattern = randi([0,1], [sobj.Div_grid^2, 1]);
            Checker_COL = repmat(sobj.checker_pattern' * sobj.stimlumi, 3, 1);


            % Stim Presentation
            % Blank %%%%%%%%%%%%%%%%%
            [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

            Screen('FillRect', sobj.wPtr, Checker_COL, sobj.Checker_RECT);
            %Flip (Stim ON)
            [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
                Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
            ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);

            %Prepare blank full screen
            Screen('FillRect', sobj.wPtr, sobj.bgcol);

            %Flip (Stim OFF)
            [sobj.vbl_3, ~, ~, ~, sobj.BeamposOFF] = ...
                Screen('Flip', sobj.wPtr, sobj.vbl_2 + sobj.Duration_sec);
            ResetStimInfo(app.StiminfoTextArea);


        case 'Decode test_v1'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Test figures 16*16 or 32*32
            %
            % Stim size:    60 deg (850pix, monitor dist:200mm)
            % Dot size:     1.875 deg for 32*32 tiles
            %               3.75 deg for 16*16 tiles
            %
            % 5 simple shapes and 5 font-images.
            %
            % This stim is used for SC Decording with Kamitani Lab.
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            %sobj.Checker_RECT = Set_RandChecker(app);
            % @Set_StimPattern.m

            % test images is defined @Load_test_images.m

            [Img_COL, sobj.img_i, sobj.img_shape] = Set_DecodeImage(sobj);
            Img_COL = reshape(Img_COL, [], 1);
            Img_COL = repmat(Img_COL' * sobj.stimlumi, 3, 1);


            % Stim Presentation
            % Blank %%%%%%%%%%%%%%%%%
            [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

            Screen('FillRect', sobj.wPtr, Img_COL, sobj.Checker_RECT);
            %Flip (Stim ON)
            [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
                Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
            ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);

            %Prepare blank full screen
            Screen('FillRect', sobj.wPtr, sobj.bgcol);

            %Flip (Stim OFF)
            [sobj.vbl_3, ~, ~, ~, sobj.BeamposOFF] = ...
                Screen('Flip', sobj.wPtr, sobj.vbl_2 + sobj.Duration_sec);
            ResetStimInfo(app.StiminfoTextArea);

        case 'Decode SC_v2'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Monochromic dot pattern 16*16 or 32*32
            %
            % Stim size:    40 deg -> variable.
            %
            % This stim is used for SC Decording with Kamitani Lab.
            % Before Decoding stimuli, Moving Bar (rand8) are insearted
            % to check data quality (stability of neurons)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Moving Bar
            if sobj.n_in_loop <= app.Blankloop.Value + 8
                sobj.subPattern = 'MovingBar';
                MovingBar;

            else

                sobj.subPattern = 'Checker';

                %sobj.Checker_RECT = Set_RandChecker(app);
                % @Set_StimPattern.m

                %Randomize Checker Pattern (1:white; 0:black)
                sobj.checker_pattern = randi([0,1], [sobj.Div_grid^2, 1]);
                Checker_COL = repmat(uint8(sobj.checker_pattern') * sobj.stimlumi, 3, 1);

                test = 1;
                if test == 0
                    % Stim Presentation
                    % Blank %%%%%%%%%%%%%%%%%
                    [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

                    Screen('FillRect', sobj.wPtr, Checker_COL, sobj.Checker_RECT);

                elseif test == 1

                    %imgtex = Screen('MakeTexture', sobj.wPtr,...
                    %   sobj.patch_checker * sobj.stimlumi);

                    imgtex = Screen('MakeTexture', sobj.wPtr,...
                        sobj.patch_white * sobj.stimlumi);


                    Screen(...
                        'DrawTextures',...
                        sobj.wPtr, imgtex, [],...
                        sobj.Checker_RECT(:, find(sobj.checker_pattern))...
                        );


                end
                
                %Flip (Stim ON)
                [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
                    Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);

                ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);

                %Prepare blank full screen
                Screen('FillRect', sobj.wPtr, sobj.bgcol);

                %Flip (Stim OFF)
                [sobj.vbl_3, ~, ~, ~, sobj.BeamposOFF] = ...
                    Screen('Flip', sobj.wPtr, sobj.vbl_2 + sobj.Duration_sec);
                ResetStimInfo(app.StiminfoTextArea);
            end

        case 'Decode test_v2'

            % Moving Bar
            if sobj.n_in_loop <= app.Blankloop.Value + 8
                sobj.subPattern = 'MovingBar';
                MovingBar;

            else

                sobj.subPattern = 'Checker';

                % test images is defined @Load_test_images.m

                [Img_COL, sobj.img_i, sobj.img_shape] = Set_DecodeImage(sobj);
                Img_COL = reshape(Img_COL, [], 1);
                Img_COL = repmat(Img_COL' * sobj.stimlumi, 3, 1);


                % Stim Presentation
                % Blank %%%%%%%%%%%%%%%%%
                [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

                Screen('FillRect', sobj.wPtr, Img_COL, sobj.Checker_RECT);
                %Flip (Stim ON)
                [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
                    Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
                ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);

                %Prepare blank full screen
                Screen('FillRect', sobj.wPtr, sobj.bgcol);

                %Flip (Stim OFF)
                [sobj.vbl_3, ~, ~, ~, sobj.BeamposOFF] = ...
                    Screen('Flip', sobj.wPtr, sobj.vbl_2 + sobj.Duration_sec);
                ResetStimInfo(app.StiminfoTextArea);
            end
            case 'Decode SC_v3'
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % Monochromic dot pattern 16*16 or 32*32
            %
            % Stim size:    40 deg -> variable.
            %
            %
            % This stim is used for SC Decording with Kamitani Lab.
            % Before Decoding stimuli, Moving Bar (rand8) are insearted
            % to check data quality (stability of neurons)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Moving Bar
            if sobj.n_in_loop <= app.Blankloop.Value + 8
                sobj.subPattern = 'MovingBar';
                MovingBar;

            else

                sobj.subPattern = 'Checker';

                %sobj.Checker_RECT = Set_RandChecker(app);
                % @Set_StimPattern.m

                %Randomize Checker Pattern (1:white; 0:black)
                sobj.checker_pattern = randi([0,1], [sobj.Div_grid^2, 1]);
                Checker_COL = repmat(sobj.checker_pattern' * sobj.stimlumi, 3, 1);


                % Stim Presentation
                % Blank %%%%%%%%%%%%%%%%%
                [sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

                Screen('FillRect', sobj.wPtr, Checker_COL, sobj.Checker_RECT);
                %Flip (Stim ON)
                [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
                    Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
                ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);

                %Prepare blank full screen
                Screen('FillRect', sobj.wPtr, sobj.bgcol);

                %Flip (Stim OFF)
                [sobj.vbl_3, ~, ~, ~, sobj.BeamposOFF] = ...
                    Screen('Flip', sobj.wPtr, sobj.vbl_2 + sobj.Duration_sec);
                ResetStimInfo(app.StiminfoTextArea);
            end

    end


else
    % blank loop
    fprintf("Blank loop: #%d.\n", n_blankloop)

    text_stim_info = {'';'';'';'';'';''};
    text_stim_info{1} = ['Blank Loop #:', num2str(n_blankloop)];
    text_stim_info{2} = ['loop #: ', num2str(sobj.n_in_loop)];
    app.StiminfoTextArea.Value = text_stim_info;
    drawnow;

    %Prepare Blank
    Screen('FillRect', sobj.wPtr, sobj.bgcol);
    %Flip (for dealy)
    [sobj.vbl_1, sobj.onset, sobj.flipend] = Screen('Flip', sobj.wPtr);
    %Flip (Stim ON)
    [sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
        Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
    %Flip (Stim OFF)
    [sobj.vbl_3, ~, ~, ~, sobj.BeamposOFF] = ...
        Screen('Flip', sobj.wPtr, sobj.vbl_2 + sobj.Duration_sec);
end

%Return
app.sobj = sobj;

%setRTS(app.SerPort , false) %TTL low -> daq

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Prepare_stim_spot(Size)
        flag = 1;

        sobj = Set_StimPos_Spot(app.PositionOrderDropDown.Value, sobj);

        maxDiameter = round(max(Size) * 1.5);

        if flag == 0
            Rect = CenterRectOnPointd([0, 0, Size(1), Size(2)], ...
                sobj.StimCenterPos(1), sobj.StimCenterPos(2));

            % Luminance or color
            %%%%% add code %%%%%

            % Prepare Screen
            Screen(sobj.Shape, sobj.wPtr, sobj.stimColor, Rect, maxDiameter);

        elseif flag == 1
            %Screen('DrawDots', windowPtr, xy [,size] [,color] [,center] [,dot_type][, lenient]);
            %Screen('DrawDots', window, [dotXpos dotYpos], dotSizePix, dotColor, [], 2);
            % size: diameter in pixe;
            % center: relative to center of the monitor([0, 0])
            % dot_type:2 high quality anti-aliasing
            %

            X = sobj.StimCenterPos(1);
            Y = sobj.StimCenterPos(2);

            Screen('DrawDots', sobj.wPtr, [X, Y], Size(1), sobj.stimColor,...
                [], dot_type);
        end

    end

    function MovingBar
        %Bar width and height in deg;
        sobj.bar_height = 65; %fixed height
        sobj.bar_witdh = sobj.StimSize_deg(1);

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
        ShowStimInfo(sobj, app.StiminfoTextArea, app.Blankloop.Value);
        drawnow;

        %Mvoing flips
        for i_flips = 2:flipnum
            Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
            Screen('DrawTexture', sobj.wPtr, im_tex, [], tex_pos(i_flips,:), -sobj.MoveDirection);
            %Flip
            vbl = Screen('Flip', sobj.wPtr, vbl + (sobj.MonitorInterval/2));
        end

        %Stim OFF
        sobj = MovingStim_off(sobj, app.StiminfoTextArea, vbl);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end