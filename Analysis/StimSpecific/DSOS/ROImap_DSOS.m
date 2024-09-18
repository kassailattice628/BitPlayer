function [imgBG, RGB] = ROImap_DSOS(im, type, pn)

imgsz = im.imgsz;
mask = im.Mask_ROIs;
imgBG = zeros(imgsz(1) * imgsz(2), 3);
RGB = [];

if nargin == 2
    % Use positive response
    pn = 1;
end

switch type
    case 'DS'
        n = 36;
        h_list = linspace(0, 1, n);
        angle_list = linspace(0, 2*pi, n);
        L = im.L_DS(pn, :);
        Ang = im.Ang_DS(pn, :);
        if pn == 1
            rois = im.roi_DS_positive;
        elseif pn == 2
            rois = im.roi_DS_negative;
        end

        %%%%%
        for roi = rois
            if L(roi) < 0.2
                disp(roi)
                continue
            end
            %set HSV
            ang1 = find(angle_list > Ang(roi), 1, 'first');
            ang2 = find(angle_list <= Ang(roi), 1, 'last');
            if abs(Ang(roi) - angle_list(ang1)) < abs(Ang(roi) - angle_list(ang2))
                ang = ang1;
            else
                ang = ang2;
            end

            %Hue
            h = h_list(ang);

            %Blightness
            % Bit more blight color;
            v = L(roi)*1.5;
            v(v>1) = 1;
            HSV_roi = [h, 1, v];
            RGB = hsv2rgb(HSV_roi);

            imgBG(mask(:,roi),1) = RGB(1);
            imgBG(mask(:,roi),2) = RGB(2);
            imgBG(mask(:,roi),3) = RGB(3);
        end
        imgBG = reshape(imgBG,[imgsz(1), imgsz(2), 3]);
        %%%%% plot %%%%%
        %figure;
        imshow(imgBG);
        hold on
        % vector map
        [U, V] = pol2cart(Ang, L);
        quiver(im.Centroid(1, rois), im.Centroid(2,rois),...
            U(rois)*50, -V(rois)*50,...
            'AutoScale', 'off', 'Color', 'w')
        axis ij
        axis([0, imgsz(1), 0, imgsz(2)])
        hold off
        colormap(hsv(n));


    case 'OS'
        % For OS cell, only slanted bars are drawn.
        n = 18;
        h_list = linspace(0, 1, n);
        angle_list = linspace(-pi/2, pi/2, n);

        if pn == 1
            rois = im.roi_OS_positive;
        elseif pn == 2
            rois = im.roi_OS_negative;
        end
        L = im.L_OS(pn, :);
        Ang = im.Ang_OS(pn, :);
        RGB = zeros(length(rois), 3);

        for roi = rois
            if L(roi) < 0.15
                disp(roi)
                continue
            end
            disp(roi)
            %set HSV
            ang1 = find(angle_list > Ang(roi), 1, 'first');
            ang2 = find(angle_list <= Ang(roi), 1, 'last');

            if abs(Ang(roi) - angle_list(ang1)) <...
                    abs(Ang(roi) - angle_list(ang2))
                ang = ang1;
            else
                ang = ang2;
            end

            %Hue
            h = h_list(ang);
            %Blightness
            v = L(roi) * 2;
            v(v>1) = 1;
            HSV_roi = [h, 1, v];
            RGB(rois == roi, :) = hsv2rgb(HSV_roi);
        end
        imgBG = zeros(imgsz(1), imgsz(2));
        %%%%% plot %%%%%
        %figure;
        imshow(imgBG);
        hold on
        for i2 = rois
            Put_template_bar(i2, im.Centroid, RGB(rois==i2, :), Ang(i2));
        end
        hold off

    case 'Non Selective'
        rois = cell(1,3);
        rois{1} = union(im.roi_non_selective_positive,...
            im.roi_non_selective_negative); %im.roi_non_selective;

        if size(rois{1},1)~=1
            rois{1} = rois{1}';
        end
        rois{2} = im.roi_non_selective_positive;
        rois{3} = im.roi_non_selective_negative;

        imgBG = zeros(imgsz(1) * imgsz(2), 3);
        for roi = rois{1}
            if ismember(roi, rois{3})
                % negative response
                imgBG(mask(:,roi),1) =  1;%im.R_max(i2);
                imgBG(mask(:,roi),2) =  0;
                imgBG(mask(:,roi),3) =  1;

            elseif ismember(roi, rois{2})
                % non-selective positive response
                imgBG(mask(:,roi),1) =  0.4;%im.R_max(i2);
                imgBG(mask(:,roi),2) =  1;
                imgBG(mask(:,roi),3) =  0.6;
            end
        end
        imgBG = reshape(imgBG,[imgsz(1), imgsz(2), 3]);
        %%%%% plot %%%%%
        %figure;
        imshow(imgBG);
end

end