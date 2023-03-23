function [B, data_bstrp_]= Bootstrap_DSI_OSI(im, type, shuffle)
%
%
%
if nargin == 2
    shuffle = false;
end

n_bstrp = im.n_bstrp;
n_ROIs = im.Num_ROIs;

%% Setting 
switch type
    case 'Direction'
        dFF_peak = im.dFF_peak_each_positive;
        stim = im.stim_directions;

    case 'Orientation'
        dFF_peak = im.dFF_peak_each_positive_orientation;
        stim = im.stim_orientations;
end

%%
if shuffle
    dFF_peak = Shuffle(dFF_peak, n_ROIs);
    txt_sh = [type,'(shuffled)'];
else
    txt_sh = type;
end

%%
% B: [DSI/OSI, Preferred Angle]
B = zeros(n_bstrp, 2, n_ROIs);

%
tic;
%
n_col = size(dFF_peak, 2);
data_bstrp_ = zeros(n_bstrp, n_col, n_ROIs);

for roi = 1 : n_ROIs
%for roi = 182
    data = dFF_peak(:,:,roi);
    data_bstrp = zeros(n_bstrp, n_col);

    % Remove NaN by column...
    for c = 1:size(data,2)
        d = data(:, c);
        d = d(~isnan(d));
        if isempty(d)
            % All data is NaN
            data_bstrp(:, c) = NaN(n_bstrp, 1);
        elseif length(d) > 1
            data_bstrp(:, c) = bootstrp(n_bstrp, @mean, d);
        elseif length(d) == 1
            data_bstrp(:, c) = repmat(d, n_bstrp, 1);
        end
    end
    data_bstrp_(:,:,roi) = data_bstrp;

    % Calculate bootstrapped DS/OS index, Preferred angle
    B(:, :, roi) = Get_Boot_selectivity(data_bstrp, stim, type);

    % Report progress
    if rem(roi, 10) == 0
        fprintf('Running bootstrap %s, ROI#%d.\n', txt_sh, roi)
        toc;
    end
end


end

%%
function B_ = Get_Boot_selectivity(d_bstrp, stim, type)
%
% Calculate vectoraveraging
% type: 'Direction' or 'Orientation'
%

%DSI/OSI, Preferred Angle
B_ = zeros(size(d_bstrp, 1), 2);

parfor i = 1: size(d_bstrp, 1)
%for i = 1: size(d_bstrp, 1)
    d = d_bstrp(i,:);
    [L, Ang] = VectorAveraging(d, stim, type);
    B_(i, :) = [L, Ang];
end

end
%% Shuffled dataset calculate p_value.
function d_shuflled = Shuffle(d, rois)

d_shuflled = d * 0;
for i = 1:rois
    ii = 1;

    while ii
        d_ = d(:,:, i);

        i1 = size(d_,1); % n_trial
        i2 = size(d_,2); % n_stim
        d_ = reshape(d_, [], 1);
        d_ = d(randperm(length(d_)));
        d_ = reshape(d_, i1, i2);
        
        %check if all columb is NaN re-generate shuffle
        if sum(sum(isnan(d_)) == i1) ~= 0
            fprintf('Re-generate shuffle for ROI#%d.\n', i)
        else
            ii = 0;
            d_shuflled(:,:,i) = d_;
        end
    end
end

end






