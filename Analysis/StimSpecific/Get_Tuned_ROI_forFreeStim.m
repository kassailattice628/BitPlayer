function im = Get_Tuned_ROI_forFreeStim(im, s)
%
% Extract tuning selective roi
% This function is called in Get_Trial_Averages.m
% For free stimuli (ex. MovingBar Free), tuned ROI is defined conpared with
% original data and shuffling data
%

disp('Caluclate Tuned ROI by shuffling...')
n_permutation = 1000;
%% Get ROIs with selectivity
switch s.Pattern
        
    case {'Moving Bar', 'Shifting Grating'}
        %stim = parallel.pool.Constant(im.stim_directions);
        stim = im.stim_directions;
        n_stim = length(im.stim_directions);
        DSI_shuffle = nan(2, n_permutation);
        OSI_shuffle = DSI_shuffle;

        roi_DS_p = [];
        roi_OS_p = [];
        roi_DS_n = [];
        roi_OS_n = [];
        
        for i_ROI = im.roi_res
            %DSI

            for i = 1:n_permutation

                y = im.dFF_peak_each_positive(1, :, i_ROI);
                y_n = -im.dFF_peak_each_negative(1, :, i_ROI);
                i_shuffled= randperm(n_stim);
                stim_shuffled = stim(i_shuffled);
                stim_shuffled_n = stim(i_shuffled);

                %remove sag
                y(y < 0) = nan;
                y_n(y_n < 0) = nan;

                %remove nan
                i_rem = isnan(y);
                y(i_rem) = [];
                stim_shuffled(i_rem) = [];

                i_rem = isnan(y_n);
                y_n(i_rem) = [];
                stim_shuffled_n(i_rem) = [];



                %% Calculate shuffled DSI/OSI
                [DSI_shuffle(1, i), ~] = ...
                    VectorAveraging(y, stim_shuffled, 'Direction');
                [OSI_shuffle(1, i), ~] = ...
                    VectorAveraging(y, stim_shuffled, 'Orientation');


                [DSI_shuffle(2, i), ~] = ...
                    VectorAveraging(y_n, stim_shuffled_n, 'Direction');
                [OSI_shuffle(2, i), ~] = ...
                    VectorAveraging(y_n, stim_shuffled_n, 'Orientation');
            end
            
            threshold = 0.01;
            %Cutoff 5%
            if sum(DSI_shuffle(1,:) > im.L_DS(1, i_ROI))/n_permutation < threshold
                roi_DS_p = [roi_DS_p, i_ROI];
            end

            if sum(OSI_shuffle(1,:) > im.L_OS(1, i_ROI))/n_permutation < threshold
                roi_OS_p = [roi_OS_p, i_ROI];
            end

            if sum(DSI_shuffle(2,:) > im.L_DS(2, i_ROI))/n_permutation < threshold
                roi_DS_n = [roi_DS_n, i_ROI];
            end

            if sum(OSI_shuffle(2,:) > im.L_OS(2, i_ROI))/n_permutation < threshold
                roi_OS_n = [roi_OS_n, i_ROI];
            end
        end

        % p: positive, n: negative, and merged 
        im.roi_DS = union(roi_DS_p, roi_DS_n);
        if size(im.roi_DS, 1) ~= 1
            im.roi_DS = im.roi_DS';
        end
        im.roi_OS = union(roi_OS_p, roi_OS_n);
        if size(im.roi_OS, 1) ~= 1
            im.roi_OS = im.roi_OS';
        end
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
    case 'Static Bar'
        

end

disp('Done.')
end