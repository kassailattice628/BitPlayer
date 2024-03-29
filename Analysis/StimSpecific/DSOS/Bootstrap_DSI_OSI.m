function [B_DS, B_OS, data_bstrp_ds, data_bstrp_os] =...
    Bootstrap_DSI_OSI(im, shuffle)
%
%
%

n_bstrp = im.n_bstrp;
dFF_peak = im.dFF_peak_each_positive;
n_stim = size(dFF_peak, 2);
n_ROIs = im.Num_ROIs;

if nargin == 1
    shuffle = false;
end


%data_bstrp = zeros(n_bstrp, n_stim, n_ROIs);
%% Resampling
if shuffle
    dFF_peak = Shuffle(dFF_peak);
end

data_bstrp_ds = bootstrp(n_bstrp, @(x) [mean(x, 'omitnan')], dFF_peak);
data_bstrp_ds = reshape(data_bstrp_ds,[n_bstrp, n_stim, n_ROIs]);

for i = 1:n_ROIs
    for ii = 1:n_stim/2
        dFF_peak_os(:,ii,i) = [dFF_peak(:,ii,i); dFF_peak(:,ii+n_stim/2,i)];
    end
end
data_bstrp_os = bootstrp(n_bstrp, @(x) [mean(x, 'omitnan')], dFF_peak_os);
data_bstrp_os = reshape(data_bstrp_os,[n_bstrp, n_stim/2, n_ROIs]);


%% Vector Avaraging;
B_DS = zeros(n_bstrp, 2, n_ROIs); %L, Ang
B_OS = zeros(n_bstrp, 2, n_ROIs); %L, Ang

directions = im.stim_directions;
orientations = im.stim_orientations;

for i = 1:n_ROIs
    d = data_bstrp_ds(:,:,i);
    %do = data_bstrp_os(:,:,i);
    [B_DS(:,1,i), B_DS(:,2, i)] =...
        VectorAveraging(d, directions, 'Direction');
    [B_OS(:,1,i), B_OS(:,2, i)] =...
        VectorAveraging(d, orientations, 'Orientation');
end

%{
%%%%%%
if nargin == 1
    shuffle = false;
end

n_bstrp = im.n_bstrp;
n_ROIs = im.Num_ROIs;
dFF_peak = im.dFF_peak_each_positive;


%%
% B: [DSI/OSI, Preferred Angle]
B_DS = zeros(n_bstrp, 2, n_ROIs);
B_OS = zeros(n_bstrp*2, 2, n_ROIs);

%
tic;
%

n_col = size(dFF_peak, 2); %n_stim
data_bstrp_ = zeros(n_bstrp, n_col, n_ROIs);

for roi = 1 : n_ROIs
%for roi = 182
    data = dFF_peak(:,:,roi);
    data_bstrp = zeros(n_bstrp, n_col);

    %%%%%%%%%
    % Remove NaN by column...
    % Needo to fix this?
    %%%%%%%%%

    for c = 1: n_col
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
    %%%%%%%%%%%

    % Shufflig
    if shuffle
        data_bstrp = Shuffle(data_bstrp);
        txt_sh = ' (shuffled)';
    else
        txt_sh = [];
    end

    data_bstrp_(:, :, roi) = data_bstrp;
    
    % Calculate DS/OS index and Preferred angle, using bootstrapped data
    B_DS(:, :, roi) = Get_Boot_selectivity(data_bstrp,...
        im.stim_directions, 'Direction');
    
    data_bstrp_os = [data_bstrp(:, 1:size(data_bstrp, 2)/2);...
        data_bstrp(:, (size(data_bstrp, 2)/2 + 1): end)];
    B_OS(:, :, roi) = Get_Boot_selectivity(data_bstrp_os,...
        im.stim_orientations, 'Orientation');
    
    % Report progress
    if rem(roi, 10) == 0
        fprintf('Running bootstrap%s, ROI#%d...\n', txt_sh, roi)
        toc;
    end
end
%}

end


%% Shuffled dataset for calculating p_value.
function d_shuffled = Shuffle(d)
%
% Generate shuffled dataset
%

d_shuffled = d;

%Shufflingm within the same row
for ROI = 1: size(d, 3)
    for row = 1:size(d, 1)
        i_shuffle = randperm(size(d, 2));
        d_shuffled(row, :, ROI) = d(row, i_shuffle, ROI);
    end
end


end






