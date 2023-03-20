function y = Get_Median_95Rabge(data_boot)
%
% data_boot is bootstrapped DSI, for instance.
% 

if ismatrix(data_boot)
    %for DSI/OSI and Preferred Angle
    y = zeros(3, size(data_boot, 2));
    y(1,:) = median(data_boot);
    y(2,:) = prctile(data_boot, 2.5);
    y(3,:) = prctile(data_boot, 97.5);

elseif ndims(data_boot) == 3
    %for resampling dFF
    y = zeros(3, size(data_boot, 2), (size(data_boot,3)));
    for roi = 1:size(data_boot, 3)
        d = data_boot(:,:,roi);
        y(1, :, roi) = median(d);
        y(2, :, roi) = prctile(d, 2.5);
        y(3, :, roi) = prctile(d, 97.5);
    end
end

end