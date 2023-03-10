function Plot_DSOS(im, stim, roi)
%
% plot simple DSOS properties 
%

% Remove NaN from peak matrix
% data vector for sactter plot
x = [];
y = [];

%peak = im.dFF_peak_each(:,:, roi);
peak = im.dFF_peak_each_positive(:,:, roi);

%stim = im.stim_directions';
n_stim = length(stim);
n_trial = size(peak, 1);
peak_ave = zeros(n_stim, 1);

for i = 1:n_stim
    y_ = peak(:, i);
    x_ = repmat(stim(i), n_trial, 1);
    x = [x;x_];
    y = [y;y_];
    peak_ave(i) = mean(y_, 'omitnan');
end

% Remove NaN
x(isnan(y)) = [];
y(isnan(y)) = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set color
if ismember(roi, [im.roi_DS_positive, im.roi_DS_negative]) &&...
        ismember(roi, [im.roi_OS_positive, im.roi_OS_negative])
    Col = [0.3010 0.7450 0.9330];
    TiTxt = 'Direction & Orientation selective';

elseif ismember(roi, [im.roi_DS_positive, im.roi_DS_negative])
    Col = [0 0.4470 0.7410];
    TiTxt = 'Direction selective';

elseif ismember(roi, [im.roi_OS_positive, im.roi_OS_negative])
    Col = [0.8500 0.3250 0.0980];
    TiTxt = 'Orientation selective';

elseif ismember(roi, im.roi_nores)
    Col = [0,0,0];
    TiTxt = 'No Responding';

elseif ismember(roi, im.roi_non_selective)
    Col = [0.4660 0.6740 0.1880];
    TiTxt = 'Non selective';

end

%%%%%%%%%%%%%%%%%%%%

figure
%% Raw plot
subplot(1,2,1)
hold on
%each peak data mean
plot(x, y, '.', 'Color', Col);

if im.bstrpDone
    peak_boot = im.dFF_peak_btsrp(:, roi);
    plot(stim, peak_boot, 'ro')
else
    plot(stim, peak_ave, 'bo');
end

xlim([-0.1, 2*pi+0.1])
title(['ROI# = ', num2str(roi)])
set(gca, 'xtick', [0, pi/2, pi, 3*pi/2, 2*pi],...
    'xticklabel', {'0', '\pi/2', '\pi', '3\pi/2', '2\pi'})
xlabel('Move Angle (deg)');

%% Polar plot
subplot(1,2,2)

polarplot([stim,stim(1)], [peak_ave; peak_ave(1)], 'o-', 'Color', Col);
if im.bstrpDone
    hold on;
    polarplot([stim,stim(1)], [peak_boot; peak_boot(1)], 'ro-', 'Color', Col);
end

title(TiTxt)

end
