function [gratingtex, s] = Make_GratingTexture(s)

%s = app.sobj;

%%
switch s.Pattern
    case 'Sinusoidal'
        flag_gabor = 0;
        flag_sin = 1;

    case 'Gabor'
        flag_gabor = 1;
        flag_sin = 0;

    otherwise
        flag_gabor = 0;
        flag_sin = 0;

end
%% Generate grating texture
if flag_gabor == 0    
    if flag_sin == 0
        %shifting grating
        contrastPreMultiplicator = 1;
    else
        stimlumi = double(s.stimlumi);
        contrastPreMultiplicator = 2.55/stimlumi;
    end

    switch s.Shape
        case 'FillRect'
            radius = [];
        otherwise
            %radius = s.StimSize_deg/2;
            radius = s.StimSize_pix(1)/2;
    end

    gratingtex = CreateProceduralSineGrating(...
        s.wPtr, s.StimSize_pix(1), s.StimSize_pix(2), [0,0,0,0], radius,...
        contrastPreMultiplicator);

elseif flag_gabor == 1
    %bgcol = s.bgcol/s.stimlumi;
    bgcol = double(s.bgcol)/255;
    
    gratingtex = CreateProceduralGabor(...
        s.wPtr, s.StimSize_pix(1), s.StimSize_pix(2),...
        0, [bgcol, bgcol, bgcol, 0.0]);
    
%     gabortex = CreateProceduralGabor(...
%         win, tw, th,...
%         nonsymmetric, [0.5 0.5 0.5 0.0]);

end

%% Temporal Frequency


%app.sobj = s;

