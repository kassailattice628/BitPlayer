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
        pos = p.stim1.Center_position;
        t1 = ['Position: ', div, 'x', div, '=', pos];
        t2 = ['Size: ' , num2str(s.StimSize_deg), 'deg'];
    case 'Fine Mapping'
        div = num2str(s.Div_grid);
        pos = p.stim1.Center_position;
        fpos = p.stim1.Center_position_in_FineMapArea;
        t1 = ['Center: ',pos, ' FineMapPosition: ', div, 'x', div, '=', fpos];
        t2 = ['Size: ' , num2str(s.StimSize_deg), 'deg'];
        
    case 'Moving Bar'
        t1 = ['Direction: ',...
            num2str(p.stim1.Movebar_Direction_angle_deg), 'deg'];
        t2 = ['Width: ', num2str(s.StimSize_deg), 'deg, ',...
            'Speed: ', num2str(s.MoveSpd), 'deg/s'];
end

else
    t1 = 'Blank';
    t2 = '';
end

gui1.Text = t1;
gui2.Text = t2;