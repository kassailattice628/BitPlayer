function im = Get_Tuned_ROI_byThreshold(im, s)
%
% Extract tuning selective roi
% This function is called in Get_Trial_Averages.m
%
% roi_pos_R, roi_nega_R and dFF_s_each are ectracted in
% Get_Trial_Averages.m
%
% im = app.imgobj;
% s = app.sobj;
%
% Appdesigner version 191101
% Update 20220331
%   Stop using fixed threshold for responding cell -> Use Mean + 2SD.
% 
% BitPlayer version 20230307
%

%% Get ROIs with selectivity
switch s.Pattern
        
    case {'Moving Bar', 'Shifting Grating'}
        % Set threshold
        th_DS = 0.2;
        th_OS = 0.15;

        % p: positive, n: negative, and merged 
        [roi_DS, roi_DS_p, roi_DS_n] = Find_DSOS(im.L_DS, im.roi_res, th_DS);
        [roi_OS, roi_OS_p, roi_OS_n] = Find_DSOS(im.L_OS, im.roi_res, th_OS);

        im.roi_DS = roi_DS;
        im.roi_OS = roi_OS;
        im.roi_DS_positive = roi_DS_p;
        im.roi_DS_negative = roi_DS_n;
        im.roi_OS_positive = roi_OS_p;
        im.roi_OS_negative = roi_OS_n;
        im.roi_non_selective_positive = ...
            setdiff(im.roi_positive, union(im.roi_DS_positive, im.roi_OS_positive));
        im.roi_non_selective_negative = ...
            setdiff(im.roi_negative, union(im.roi_positive,...
            [im.roi_DS, im.roi_OS]));
        im.roi_non_selective = ...
            union(im.roi_non_selective_positive, im.roi_non_selective_negative);

        %ROI_sorted
        im.roi_sortDS = Sort_ROI_by_DSOS(im, 'DS');
        im.roi_sortOS = Sort_ROI_by_DSOS(im, 'OS');

    case {'Moving Spot','Sinusoidal', 'Gabor'}

        th_DS = 0.15;
        [roi_DS, roi_DS_p, roi_DS_n] = Find_DSOS(im.L_DS, im.roi_res, th_DS);
        im.roi_DS = roi_DS;
        im.roi_DS_positive = roi_DS_p;
        im.roi_DS_negative = roi_DS_n;
        im.roi_non_selective = setdiff(im.roi_res, roi_DS);

        im.roi_sort = Sort_ROI_by_DSOS(im, 'DS');

    case 'Static Bar'
        
        th_OS = 0.15;
        [roi_OS, roi_OS_p, roi_OS_n] = Find_DSOS(im.L_OS, im.roi_res, th_OS);
        im.roi_OS = roi_OS;
        im.roi_OS_positive = roi_OS_p;
        im.roi_OS_negative = roi_OS_n;
        im.roi_non_selective = setdiff(im.roi_res, roi_OS);

        im.roi_sort = Sort_ROI_by_DSOS(im, 'OS');
        

end

end

%% %%%%%%%%
function [roi, roi_p, roi_n] = Find_DSOS(L, roi_res, th)

%pos_nega=: 1: posotive, 2: negative
roi_p = intersect(roi_res, find(L(1,:) >= th));
roi_n = intersect(roi_res, find(L(2,:) >= th));
roi = union(roi_p, roi_n);

if size(roi, 1) ~= 1
    roi = roi';
end
end