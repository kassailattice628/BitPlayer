function im = Get_OSI_va(im)
%%%%%
%
% 'Moving Bar', 'Shifting Grating'
%
% im: imgobj
% rois: 1:im.Num_ROIs
% 
% BitPlayer version 20230307
%%%%%


peak_positive = im.dFF_peak_each_positive;
peak_negative = im.dFF_peak_each_negative;
StimAngles = im.stim_directions;
% Store, Ang: preferred angle and L:gOSI
Ang = zeros(1, im.Num_ROIs);
L = Ang;

Ang_nega = Ang;
L_nega = Ang;



rois = 1 : im.Num_ROIs;
%%
for i = rois 
    % mean pkea value;
    y_positive = mean(peak_positive(:,:,i), 'omitnan');
    y_negative = mean(-peak_negative(:,:,i), 'omitnan');

    y_positive(y_positive < 0) = nan;
    y_negative(y_negative < 0) = nan;

    % vector average for orientation
    [L(i), Ang(i)] = VectorAveraging(y_positive, StimAngles, 'Orientation');
    [L_nega(i), Ang_nega(i)] = VectorAveraging(y_negative, StimAngles, 'Orientation');
end

im.stim_orientations = StimAngles;
im.Ang_OS= [Ang; Ang_nega];
im.L_OS = [L; L_nega];

disp('Calculated OSI by vector averaging')

end

%%%%%%%%%%

