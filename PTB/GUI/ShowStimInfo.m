function ShowStimInfo(sobj, gui)
%Displaying stimulus information (and timing) in the GUI.

% Common: trial #

text_stim_info = {'';'';'';'';'';''};
text_stim_info{1} = sobj.Pattern;
text_stim_info{2} = ['loop #: ', num2str(sobj.n_in_loop)];

switch sobj.Pattern
    case {'Uni', 'Size Random'}
        %n x n matrix, position in matrix, size, 
        text_stim_info{3} = [...
            'Position: ', num2str(sobj.index_center_in_mat),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];
        text_stim_info{4} = ['Size: ', num2str(sobj.StimSize_deg),' deg'];
        

    case 'Fine Mapping'
        %fn x fn matrix, position in fine matrix, size, 
        text_stim_info{3} = [...
            'Center: ', num2str(sobj.FixPos),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];

        text_stim_info{4} = [...
            'Fine Pos: ', num2str(sobj.index_center_in_mat),...
            '/(',num2str(sobj.Div_grid), 'x',num2str(sobj.Div_grid) ')'];

        text_stim_info{5} = ['Size: ', num2str(sobj.StimSize_deg),' deg'];

    case {'Static Bar'}
        %n x n matrix, position in matrix, size(width), bar angle
        text_stim_info{3} = [...
            'Center: ', num2str(sobj.FixPos),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];

        text_stim_info{4} = [...
            'Angle: ', num2str(sobj.BarOrientation), ' deg'];

        text_stim_info{5} = ['Width: ', num2str(sobj.StimSize_deg),' deg'];

    case {'Moving Bar', 'Moving Spot'}
        %size(width), moving direction, moving speed
        text_stim_info{3} = [...
            'Direction: ', num2str(sobj.MoveDirection),' deg'];

        text_stim_info{4} = [...
            'Speed: ', num2str(sobj.MoveSpd), ' deg/sec'];

        text_stim_info{5} = ['Width: ', num2str(sobj.StimSize_deg),' deg'];

    case {'Sinusoidal', 'Shifting Grating', 'Gabor'}
        %spatial freq, tempora; freq, size
        text_stim_info{3} = [...
            'Direction: ', num2str(sobj.MoveDirection),' deg'];

        text_stim_info{4} = [...
            'Spatial Freq: ', num2str(sobj.SpatialFreq), ' cpd'];

        text_stim_info{5} = [...
            'Temporal Freq: ', num2str(sobj.TemporalFreq),' Hz'];

    case 'Looming'
        %looming speed, final size
        text_stim_info{3} = [...
            'Center: ', num2str(sobj.FixPos),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];

        text_stim_info{4} = [...
            'Speed: ', num2str(sobj.LoomingSpd), ' deg/sec'];

        text_stim_info{5} = ['Max Size: ', num2str(sobj.LoomingMaxSize),' deg'];
    
    case 'Images'
        %n x n matrix, position in matrix, size, image #

    case 'Mosaic'
        %size, density

    case 'Mouse Cursor'
        %********

    case {'2 points', 'Black & White'}
end

gui.Value = text_stim_info;
gui.BackgroundColor = [1,1,0.8];
drawnow;

end