function Show_ROImap(app)
%
% Show ROI map image colorlized with tuning properties.
%
%%
im = app.imgobj;
s = app.sobj;
imgsz = im.imgsz;
if length(imgsz)==1
    imgsz = [imgsz, imgsz];
end

% Prepare background img
imgBG = zeros(imgsz(1) * imgsz(2), 3);

%% Make color map
switch s.Pattern

    case {'Moving Bar', 'Shifting Grating'}

        figure,
        t = tiledlayout(2,2);
        nexttile
        ROImap_DSOS(im, 'DS');

        nexttile
        ROImap_DSOS(im, 'OS');

        nexttile
        ROImap_DSOS(im, 'Non Selective');
        
        t.TileSpacing = 'compact';
        t.Padding = 'compact';

    case {'Sinusoidal', 'Gabor', 'Moving Spot'}
        ROImap_DSOS(im, 'DS');

    case 'Static Bar'
        RoImap_DSOS(im, 'OS');

%%%%%%%%%%Å@Ç±Ç±Ç©ÇÁÇµÇΩÇÕÇ‹Çæ %%%%%%%%%%
    case 'Uni'
        map_nxn(s, im);
        
        if isfield(im, 'b_GaRot2D')
            imgBG = zeros(imgsz(1) * imgsz(1), 3);
            map_nxn_use_fitdata;
        end
        
    case 'Fine Mapping'
        map_nxn(2);
        if isfield(im, 'b_GaRot2D')
            imgBG = zeros(imgsz(1) * imgsz(2), 3);
            map_nxn_use_fitdata;
        end

    case 'Size Random'
        map_size;

    otherwise
end

end %End of Col_ROIs