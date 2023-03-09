function ROImap_SizeRandom(s, im)
%
% ROImap
%

imgsz = im.imgsz;

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