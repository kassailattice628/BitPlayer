function Show_ROImap(app)
%
% Show ROI map image colorlized with tuning properties.
%
%%
im = app.imgobj;
s = app.sobj;
imgsz = im.imgsz;

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


    case 'Size Random'
        map_size;
        
    case {'Sinusoidal', 'Gabor', 'Moving Spot'}
        ROImap_DSOS(im, 'DS');
    case 'Static Bar'
        RoImap_DSOS(im, 'OS');

        

        
    case {'Uni'}
        map_nxn(1);
        
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
        

    otherwise
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function map_size
        imgBG2 = zeros(imgsz(1) * imgsz(2), 3);
        imgBG3 = zeros(imgsz(1) * imgsz(2), 3);
        
        %RGB_list = colormap(jet(7));
        RGB_list = colormap(jet(size(im.R_size,1)));
        for i2 = im.roi_res
            [~, best_i_on] = max(im.R_size(1:5, i2, 1));
            [~, best_i_off] = max(im.R_size(1:5, i2, 2));
            %ON
            RGB = RGB_list(best_i_on,:);
            imgBG(im.Mask_rois(:,i2),1) = RGB(1);
            imgBG(im.Mask_rois(:,i2),2) = RGB(2);
            imgBG(im.Mask_rois(:,i2),3) = RGB(3);
            %OFF
            RGB2 = RGB_list(best_i_off,:);
            imgBG2(im.Mask_rois(:,i2),1) = RGB2(1);
            imgBG2(im.Mask_rois(:,i2),2) = RGB2(2);
            imgBG2(im.Mask_rois(:,i2),3) = RGB2(3);
            
            
            
            if size(im.R_size, 3) == 3
                [~, best_i_onoff] = max(im.R_size(1:5, i2, 3));
                RGB3 = RGB_list(best_i_onoff,:);
                imgBG3(im.Mask_rois(:,i2),1) = RGB3(1);
                imgBG3(im.Mask_rois(:,i2),2) = RGB3(2);
                imgBG3(im.Mask_rois(:,i2),3) = RGB3(3);
            end
            
            
        end
        
        imgBG = reshape(imgBG,[imgsz(1), imgsz(2), 3]);
        imgBG2 = reshape(imgBG2,[imgsz(1), imgsz(2), 3]);
        imgBG3 = reshape(imgBG3,[imgsz(1), imgsz(2), 3]);
        
        
        %show image
        figure
        subplot(1,2,1)
        imshow(imgBG)
        %colormap(jet(7))
        colormap(jet(size(im.R_size,1)))
        colorbar
        
        subplot(1,2,2)
        imshow(imgBG2)
        colorbar
        
        figure
        imshow(imgBG)
        figure
        imshow(imgBG2)
        
        figure
        imshow(imgBG3)
        %}
        
    end

%% %%%%%%%%%%%%%%%%%%%% %%
    
        
        %%


%% %%%%%%%%%%%%%%%%%%%% %%
    function map_nxn(type)
        
        if type == 1
            div = s.divnum;
        elseif type == 2
            div = s.div_zoom;
        end
        
        % Colorize ROI along with stimulus positions (N x N divisions).
        
        %hue -> along column (=vertical position)
        h_list = linspace(0, 0.9, div);
        %blightness value -> along row (=horizontal position)
        v_list = linspace(0.4, 1, div);
        
        %stim position
        H = repmat(h_list', 1, div);
        V = repmat(v_list, div, 1);
        for n1 = 1:div
            for n2 = 1:div
                RGB_stim(n1, n2, :) = hsv2rgb([H(n1, n2), 1, V(n1, n2)]);
            end
        end
        
        figure
        imagesc(RGB_stim)
        
        %roiごとに best position を出す．
        %best positionごとに，hue と value を与えて
        %roiを色付けする
        [val, ind] = max(max(im.dFF_s_ave,[],1));
        
        for i2 = 1:im.maxROIs
            %h(=hue) for vertical position
            %h = h_list(ceil(ind(:,:,i2)/div));
            h = H(ind(:,:,i2));
            
            %v(=blightness value) for horizontal position
            %v_res = rem(ind(:,:,i2), div);
            v_res = V(ind(:,:,i2));
            
            if val <= 0.15
                %no res cell is not colorized (blightness = 0)
                v = 0;
            else
                v = v_res;
            end
            
            HSV_roi = [h, 1, v];
            RGB = hsv2rgb(HSV_roi);
            imgBG(im.Mask_rois(:,i2), 1) = RGB(1);
            imgBG(im.Mask_rois(:,i2), 2) = RGB(2);
            imgBG(im.Mask_rois(:,i2), 3) = RGB(3);
        end
        
        imgBG = reshape(imgBG, [imgsz(1), imgsz(2), 3]);
        
        %plot
        figure
        imshow(imgBG)
        axis ij
        axis([0, 320, 0, 320])
        %colormap(hsv(div))
    end


%% %%%%%%%%%%%%%%%%%%%% %%
    function map_nxn_use_fitdata
        
        color_div = 100;
        %hue -> along column (vertical position)
        h_list = linspace(0, 0.9, color_div);
        %blightness
        v_list = linspace(0.4, 1, color_div);
        
        %stim position
        RGB_stim = zeros(color_div, color_div, 3);
        H = repmat(h_list', 1, color_div);
        V = repmat(v_list, color_div, 1);
        
        for n1 = 1:color_div
            for n2 = 1:color_div
                RGB_stim(n1, n2, :) = hsv2rgb([H(n1, n2), 1, V(n1, n2)]);
            end
        end
        
        figure,
        imagesc(RGB_stim);
        
        % Fit した center (x, y) を hue と value に当てはめる
        % Fit params するときの -3 ~ 13 の範囲で 中心を評価するのでその補正
        pos_x = (im.b_GaRot2D(:,2) + 3)/16;
        pos_y = (im.b_GaRot2D(:,4) + 3)/16;
        
        
        for n = 1:im.maxROIs
            
            %h for verticak position
            i_h = knnsearch(h_list', pos_y(n));
            h = h_list(i_h);
            %v for horizontal position
            i_v = knnsearch(v_list', pos_x(n));
            v = v_list(i_v);
            
            if ismember(n, im.roi_no_res)...
                    || im.b_GaRot2D(n,1) < 0.15
                v = 0;
            end
            
            HSV_roi = [h, 1, v];
            RGB = hsv2rgb(HSV_roi);
            imgBG(im.Mask_rois(:,n), 1) = RGB(1);
            imgBG(im.Mask_rois(:,n), 2) = RGB(2);
            imgBG(im.Mask_rois(:,n), 3) = RGB(3);
        end
        imgBG = reshape(imgBG, [imgsz(1), imgsz(2), 3]);
        
        %plot
        figure
        imshow(imgBG)
        axis ij
        axis([0, imgsz(1), 0, imgsz(2)])
        
    end

end %End of Col_ROIs