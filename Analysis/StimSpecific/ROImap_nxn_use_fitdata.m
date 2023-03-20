function ROImap_nxn_use_fitdata(s, im)
%
% Use fitted data for colorlize ROI in nxn stimulus
% (Uni or Fine Mapping)
%

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


%%%%%%%%%%
figure,
tiledlayout(2,4)
nexttile([1,2])
imagesc(RGB_stim);

%%%%%%%%%%

% Use fitted response center (x,y) is used used as hue and blightness.

% Correction of estimated parameters 
% Fit params するときの -3 ~ 13 の範囲で 中心を評価するのでその補正

pos_x = (im.b_GaRot2D(:,2) + 3)/16;
pos_y = (im.b_GaRot2D(:,4) + 3)/16;


for n = 1:im.Num_ROIs

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
nexttile([1,2])
imshow(imgBG)
axis ij
axis([0, imgsz(1), 0, imgsz(2)])

end