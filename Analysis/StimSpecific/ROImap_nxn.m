function ROImap_nxn(s, im)
%
% Colorize ROI along with stimulus positions (N x N divisions).
%
% s:    sobj
% im:   imgobj
%
%%

imgBG = zeros(size(im.Mask_ROIs, 1), 3);
imgsz = sqrt(size(im.Mask_ROIs, 1));

switch s.Pattern
    case 'Uni'
        div = s.DivNum;
    case 'Fine Mapping'
        div = s.Div_grid;
end

% hue -> along column (=vertical position)
h_list = linspace(0, 0.9, div);
% blightness -> along row (=horizontal position)
v_list = linspace(0.4, 1, div);

% stim position
H = repmat(h_list', 1, div);
V = repmat(v_list, div, 1);

for n1 = 1:div
    for n2 = 1:div
        RGB_stim(n1, n2, :) = hsv2rgb([H(n1, n2), 1, V(n1, n2)]);
    end
end

% Show stim position as color matrix
figure
tiledlayout(1,2)
nexttile;
imagesc(RGB_stim)
daspect([1 1 1])
title("Stim Pos")

%% %%%%%%%%%%%%%%%%%
%
% Calculate best stim position for each ROI
% The color of ROI based on the best stim position using hue & blightness
%
%%%%%%%%%%%%%%%%%%

[val, ind] = max(max(im.dFF_stim_average, [], 1));

for i2 = 1:im.Num_ROIs
    % Hue for vertical position
    h = H(ind(:,:,i2));

    % Blightness for horizontal position
    if val <= 0.15 %threshold for
        %no res cell is not colorized (blightness = 0)
        v = 0;
    else
        v = V(ind(:,:,i2));
    end

    HSV_roi = [h, 1, v];
    RGB = hsv2rgb(HSV_roi);
    imgBG(im.Mask_ROIs(:,i2), 1) = RGB(1);
    imgBG(im.Mask_ROIs(:,i2), 2) = RGB(2);
    imgBG(im.Mask_ROIs(:,i2), 3) = RGB(3);
end

% Reshape image
imgBG = reshape(imgBG, [imgsz, imgsz, 3]);

%Plot max position projection.
nexttile;
imshow(imgBG)
axis ij
axis([0, 320, 0, 320])
title("Max Resp Pos")

%% Show Center of 2D Gaussian fit 





%% %%%%%%%%%%%%%%%%%
%
% Reconstruction of viewing location
% by summing up all responded position and 
% The color of ROI based on the best stim position using hue & blightness
%
%%%%%%%%%%%%%%%%%%


end