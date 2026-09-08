function ShowStimInfo(sobj, gui, blank)
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

        fprintf('StimPos: %u x %u = %u; Size: %u deg\n\n',...
                    sobj.DivNum, sobj.DivNum, sobj.index_center_in_mat, sobj.StimSize_deg);

    case 'Fine Mapping'
        %fn x fn matrix, position in fine matrix, size, 
        text_stim_info{3} = [...
            'Center: ', num2str(sobj.FixPos),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];

        text_stim_info{4} = [...
            'Fine Pos: ', num2str(sobj.index_center_in_mat),...
            '/(',num2str(sobj.Div_grid), 'x',num2str(sobj.Div_grid) ')'];

        text_stim_info{5} = ['Size: ', num2str(sobj.StimSize_deg),' deg'];

        % index_center_in_mat is [1 x k] when MultiDot is active (k>1), so
        % print it as a list rather than feeding it straight into %u slots
        % (which would cycle the format string across all k values).
        fprintf('StimPos: %ux%u, idx=[%s] (k=%d)\n\n',...
            sobj.Div_grid, sobj.Div_grid, num2str(sobj.index_center_in_mat), ...
            numel(sobj.index_center_in_mat));

    case 'Fine Mapping Free'
        % 単一点/複数点(MultiDot)どちらでもStimCenterPosは[k x 2]
        % (k=1のときも1行)なので、index_center_in_mat(グリッド版でのみ
        % 定義されるフィールド)には依存せずここから直接組み立てる。
        text_stim_info{3} = [...
            'Center: ', num2str(sobj.FixPos),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];
        text_stim_info{4} = ['Size: ', num2str(sobj.StimSize_deg),' deg'];
        if isfield(sobj, 'UseMultiDot') && sobj.UseMultiDot
            text_stim_info{5} = ['Points: k=', num2str(size(sobj.StimCenterPos,1))];
        end

        % コマンドウィンドウにも、実際にParamsSaveへ保存する値
        % (StimCenterPos: モニター上の絶対ピクセル座標)と同じものを
        % 表示する(保存データとの対応を追いやすくするため)。
        fprintf('StimPos (free): k=%d, pos_pix=[%s]\n\n', ...
            size(sobj.StimCenterPos,1), mat2str(sobj.StimCenterPos));

    case {'Static Bar'}
        %n x n matrix, position in matrix, size(width), bar angle
        text_stim_info{3} = [...
            'Center: ', num2str(sobj.FixPos),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];

        text_stim_info{4} = [...
            'Angle: ', num2str(sobj.BarOrientation), ' deg'];

        text_stim_info{5} = ['Width: ', num2str(sobj.StimSize_deg),' deg'];

        fprintf('Orientation: %u deg \n', sobj.BarOrientation);

    case {'Moving Bar', 'Moving Spot'}
        %size(width), moving direction, moving speed
        text_stim_info{3} = [...
            'Direction: ', num2str(sobj.MoveDirection),' deg'];

        text_stim_info{4} = [...
            'Speed: ', num2str(sobj.MoveSpd), ' deg/sec'];

        text_stim_info{5} = ['Width: ', num2str(sobj.StimSize_deg),' deg'];
        
        fprintf('Move direction: %u deg \n', sobj.MoveDirection);

    case {'Sinusoidal', 'Shifting Grating', 'Gabor'}
        %spatial freq, tempora; freq, size
        text_stim_info{3} = [...
            'Direction: ', num2str(sobj.MoveDirection),' deg'];

        text_stim_info{4} = [...
            'Spatial Freq: ', num2str(sobj.SpatialFreq), ' cpd'];

        text_stim_info{5} = [...
            'Temporal Freq: ', num2str(sobj.TemporalFreq),' Hz'];

        fprintf('Dir: %u deg; SF: %.2f cpd; TF: %.2f Hz\n',...
            sobj.MoveDirection, sobj.SpatialFreq, sobj.TemporalFreq);

    case 'Looming'
        %looming speed, final size
        text_stim_info{3} = [...
            'Center: ', num2str(sobj.FixPos),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];

        text_stim_info{4} = [...
            'Speed: ', num2str(sobj.LoomingSpd), ' deg/sec'];

        text_stim_info{5} = ['Max Size: ', num2str(sobj.LoomingMaxSize),' deg'];

        fprintf('\n')
    
    case 'Random Dot Motion'
        %moving direction, moving speed
        text_stim_info{3} = [...
            'Direction: ', num2str(sobj.MoveDirection),' deg'];

        text_stim_info{4} = [...
            'Speed: ', num2str(sobj.MoveSpd), ' deg/sec'];

        text_stim_info{5} = ['Coherence: ', num2str(sobj.CoherenceRDM*100),' %'];

        fprintf('\n')

    case 'Image Presentation'
        %n x n matrix, position in matrix, size, image
        text_stim_info{3} = [...
            'Position: ', num2str(sobj.index_center_in_mat),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];
        text_stim_info{4} = ['Size: ', num2str(sobj.StimSize_deg),' deg'];
        text_stim_info{5} = ['Image: #', num2str(sobj.img_i),...
            ': ', sobj.img_fname];
        fprintf('\n')

    case {'Search V1_Coarse'}

        text_stim_info{3} = [...
            'Center: ', num2str(sobj.FixPos),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];

        text_stim_info{4} = [...
            'Direction: ', num2str(sobj.MoveDirection),' deg'];
        fprintf('\n')
        
    case {'Search V1_Fine'}
        
        text_stim_info{3} = [...
            'Center: ', num2str(sobj.FixPos),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];

        text_stim_info{4} = [...
            'Fine Pos: ', num2str(sobj.index_center_in_mat),...
            '/(',num2str(sobj.Div_grid), 'x',num2str(sobj.Div_grid) ')'];

        text_stim_info{5} = [...
            'Direction: ', num2str(sobj.MoveDirection),' deg'];
        fprintf('\n')

    case 'Mosaic'
        %size, density

%     case 'Decode SC_v1'
%         %Decoding SC: random dot n by n
%         text_stim_info{3} = [...
%             'Position: ', num2str(num2str(sobj.FixPos)),...
%             '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];
%         text_stim_info{4} = '';%['Size: ', num2str(sobj.StimSize_deg),' deg'];
% 
% 
%     case 'Decode test_v1'
%         text_stim_info{3} = [...
%             'Position: ', num2str(num2str(sobj.FixPos)),...
%             '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];
%         text_stim_info{4} = sobj.img_shape;

    case {'Decode SC', 'Decode SC_v2'}
        if sobj.n_in_loop <= blank + 8

            %size(width), moving direction, moving speed
            text_stim_info{3} = [...
                'Direction: ', num2str(sobj.MoveDirection),' deg'];
            text_stim_info{4} = [...
                'Speed: ', num2str(sobj.MoveSpd), ' deg/sec'];
            text_stim_info{5} = ['Width: ', num2str(sobj.StimSize_deg),' deg'];
            fprintf('Move direction: %u deg \n', sobj.MoveDirection);
        else

            %Decoding SC: random dot n by n
            text_stim_info{3} = [...
                'Position: ', num2str(num2str(sobj.FixPos)),...
                '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];
            text_stim_info{4} = '';

            fprintf('\n')
        end


    case {'Decode test', 'Decode test_v2'}
        if sobj.n_in_loop <= blank + 8

            %size(width), moving direction, moving speed
            text_stim_info{3} = [...
                'Direction: ', num2str(sobj.MoveDirection),' deg'];
            text_stim_info{4} = [...
                'Speed: ', num2str(sobj.MoveSpd), ' deg/sec'];
            text_stim_info{5} = ['Width: ', num2str(sobj.StimSize_deg),' deg'];
            fprintf('Move direction: %u deg \n', sobj.MoveDirection);
        else
            text_stim_info{3} = [...
                'Position: ', num2str(num2str(sobj.FixPos)),...
                '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];
            text_stim_info{4} = sobj.img_shape;
            fprintf('\n');
        end


    case {'ImageNet train', 'ImageNet test'}
        if sobj.n_in_loop <= blank + 8

            %size(width), moving direction, moving speed
            text_stim_info{3} = [...
                'Direction: ', num2str(sobj.MoveDirection),' deg'];
            text_stim_info{4} = [...
                'Speed: ', num2str(sobj.MoveSpd), ' deg/sec'];
            text_stim_info{5} = ['Width: ', num2str(sobj.StimSize_deg),' deg'];

            fprintf('Move direction: %u deg \n', sobj.MoveDirection);
        else
            text_stim_info{3} = [...
                'Position: ', num2str(num2str(sobj.FixPos)),...
                '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];
            text_stim_info{4} = sobj.Pattern;
            text_stim_info{5} = sobj.ImageNet_f;

            fprintf('Image-i: %u; File: %s \n', sobj.img_i, sobj.ImageNet_f);
        end

    case 'ImageNet NoiseCorr'
        text_stim_info{3} = [...
        'Position: ', num2str(num2str(sobj.FixPos)),...
            '/(',num2str(sobj.DivNum), 'x',num2str(sobj.DivNum) ')'];
        text_stim_info{4} = sobj.Pattern;
        text_stim_info{5} = sobj.ImageNet_f;

        fprintf('Image-i: %u; File: %s \n', sobj.img_i, sobj.ImageNet_f);
        
    case 'Mouse Cursor'
        %********

    case {'2 points', 'Black & White'}
end

gui.Value = text_stim_info;
gui.BackgroundColor = [1,1,0.5];
drawnow;

end