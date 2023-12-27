function im = Get_Trial_Averages_for_orientation(im, selected_ROIs)
%
% This function is used for calculate traial average for orientation
% "Moving bar" and "Shifting Grating" stimuli.
% Stacking same data for orientation using following vars.
%
% im.dFF_stim_average
% im.dFF_peak_each
% im.dFF_peak_each_positive
% im.dFF_peak_each_negative
%

if nargin == 1
    selected_ROIs = 1:im.Num_ROIs;
end

n_stim = size(im.dFF_stim_average, 2);

%%
switch n_stim
    case {8, 12, 16}
        % Set
        [p_data, n_stim, n_roi] = size(im.dFF_stim_average);
        dFF_average_ori = zeros(p_data, n_stim/2, n_roi);

        [n_trial, n_stim, n_roi] = size(im.dFF_peak_each);
        dFF_peak_ori = NaN(n_trial*2, n_stim/2, n_roi);
        dFF_peak_positive_ori = dFF_peak_ori;
        dFF_peak_negative_ori = dFF_peak_ori;

        % Reshape for orientation
        for i = selected_ROIs

            % averaging opposite direction (= same bar orientation)
            for ii = 1:n_stim/2
                a = im.dFF_stim_average(:, ii, i);
                b = im.dFF_stim_average(:, ii+n_stim/2, i);
                dFF_average_ori(:, ii, i) = mean([a, b], 2);
            end

            % stackgin peak matrix
            a = im.dFF_peak_each(:, 1:n_stim/2, i);
            b = im.dFF_peak_each(:, n_stim/2+1:end, i);
            dFF_peak_ori(:,:,i) = [a;b];

            a = im.dFF_peak_each_positive(:, 1:n_stim/2, i);
            b = im.dFF_peak_each_positive(:, n_stim/2+1:end, i);
            dFF_peak_positive_ori(:,:,i) = [a;b];

            a = im.dFF_peak_each_negative(:, 1:n_stim/2, i);
            b = im.dFF_peak_each_negative(:, n_stim/2+1:end, i);
            dFF_peak_negative_ori(:,:,i) = [a;b];
        end


        %
        im.dFF_stim_average_orientation = dFF_average_ori;
        im.dFF_peak_each_orientation = dFF_peak_ori;
        im.dFF_peak_each_positive_orientation = dFF_peak_positive_ori;
        im.dFF_peak_each_negative_orientation = dFF_peak_negative_ori;
        %
        disp('Trial averages of dFF for orientation is generated.')


    otherwise
        %rem(n_stim, 2) ~= 0
        %errordlg('Trial average for orientation skipped.')
end

end