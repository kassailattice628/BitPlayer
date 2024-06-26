function Show_Stimspecific_params(s, p, gui1, gui2)
%
% Show stimulus specific parameters in GUI
% s:    app.sobj
% p:    app.ParamsSave{n}
% gui1: app.Params1(.text)
% gui2: app.Params2(.text)

if ~p.stim1.Blank

    switch s.Pattern
        case 'Uni'
            div = num2str(s.DivNum);
            pos = num2str(p.stim1.Center_position);
            t1 = ['Position: ', div, 'x', div, '=', pos];
            t2 = ['Size: ' , num2str(s.StimSize_deg), 'deg'];
        case 'Fine Mapping'
            div = num2str(s.Div_grid);
            pos = p.stim1.Center_position;
            fpos = p.stim1.Center_position_in_FineMapArea;
            t1 = ['Center: ',pos, ' FineMapPosition: ',...
                div, 'x', div, '=', num2str(fpos)];
            t2 = ['Size: ' , num2str(s.StimSize_deg), 'deg'];

        case 'Fine Mapping Free'
            pos = s.FixPos;
            xpix = p.stim1.CenterX_pix;
            ypix = p.stim1.CenterY_pix;
            t1 = ['Center: ',pos, ' pos(pix): (',...
                num2str(xpix), ',', num2str(ypix), ')'];
            t2 = ['Size: ' , num2str(s.StimSize_deg), 'deg'];

        case 'Size Random'
            div = num2str(s.DivNum);
            pos = num2str(p.stim1.Center_position);
            t1 = ['Position: ', div, 'x', div, '=', pos];
            sz = p.stim1.Size_deg;
            t2 = ['Size: ' , num2str(sz), 'deg'];

        case 'Moving Bar'
            t1 = ['Direction: ',...
                num2str(p.stim1.Movebar_Direction_angle_deg), 'deg'];
            t2 = ['Width: ', num2str(s.StimSize_deg), 'deg, ',...
                'Speed: ', num2str(s.MoveSpd), 'deg/s'];
        case 'Random Dot Motion'
            t1 = ['Direction: ',...
                num2str(p.stim1.MoveDirection_deg), 'deg'];
            t2 = ['Coherence: ', num2str(p.stim1.Coherence*100), '%'];

        case 'Shifting Grating'
            t1 = ['Direction: ',...
                num2str(p.stim1.Grating_Angle_deg), 'deg'];
            div = num2str(s.DivNum);
            pos = num2str(p.stim1.Center_position);
            sz = num2str(p.stim1.Size_deg);
            t2 = ['Position: ', div 'x', div, '=', pos,...
                '; Size: ', sz, 'deg'];

        case 'Image Presentation'
            div = num2str(s.DivNum);
            pos = num2str(p.stim1.Center_position);
            t1 = ['Position: ', div 'x', div, '=', pos];
            t2 = ['Image: #', num2str(p.stim1.Image_i)];

        case 'Decode test_v1'
            t1 = ['Image file:', p.stim1.Image_fname];
            t2 = '';

        case 'Decode SC_v1'
            t1 = 'Random Checker';
            t2 = '';

        case 'Decode SC_v2'
            if strcmp(p.stim1.subPattern, 'MovingBar')
                t1 = ['Direction: ',...
                    num2str(p.stim1.Movebar_Direction_angle_deg), 'deg'];
                t2 = ['Width: ', num2str(s.StimSize_deg), 'deg, ',...
                    'Speed: ', num2str(s.MoveSpd), 'deg/s'];

            elseif strcmp(p.stim1.subPattern, 'Checker')
                t1 = 'Random Checker';
                t2 = '';
            end

        case 'Decode test_v2'
            if strcmp(p.stim1.subPattern, 'MovingBar')
                t1 = ['Direction: ',...
                    num2str(p.stim1.Movebar_Direction_angle_deg), 'deg'];
                t2 = ['Width: ', num2str(s.StimSize_deg), 'deg, ',...
                    'Speed: ', num2str(s.MoveSpd), 'deg/s'];
            elseif strcmp(p.stim1.subPattern, 'Checker')

                t1 = ['Image file:', p.stim1.Image_fname];
                t2 = '';
            end

        case {'ImageNet test', 'ImageNet train'}
            if strcmp(p.stim1.subPattern, 'MovingBar')
                t1 = ['Direction: ',...
                    num2str(p.stim1.Movebar_Direction_angle_deg), 'deg'];
                t2 = ['Width: ', num2str(s.StimSize_deg), 'deg, ',...
                    'Speed: ', num2str(s.MoveSpd), 'deg/s'];
            elseif strcmp(p.stim1.subPattern, 'Image')

                t1 = ['Image file:', p.stim1.ImageNet_name];
                t2 = ['Size: ', num2str(p.stim1.Size_deg), 'deg'];
            end

    end

else
    t1 = 'Blank';
    t2 = '';
end

gui1.Text = t1;
gui2.Text = t2;