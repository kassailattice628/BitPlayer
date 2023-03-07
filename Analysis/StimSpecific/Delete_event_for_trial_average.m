function dFF_each = Delete_event_for_trial_average(...
    dFF_each, selectedROI, show)
%
% Detect outlier and remove or check data
%
% dFF_each = Peak_dFF_each
% selectedROI
% show = 1: just show outlier data and show plot.
%        0 or []: delete outliers
%

if nargin == 1
    selectedROI = 1:size(dFF_each, 2);
    show = [];
elseif nargin == 2
    show = [];
end

%% Detect outliers
for i = selectedROI
    a = dFF_each(:,:,i);
    i_out = isoutlier(a);

    if show
        % Check if detected outliers are valid
        figure, 
        [~, i2] = find(i_out);
        scatter(i2, a(i_out), 'm*')
        hold on
        [~, i2] = find(i_out==0);
        scatter(i2, a(i_out==0), 'bo')
        xlabel('Stim')
        ylabel('dFF')
    else
        % Delet event
        a(i_out) = NaN;
        dFF_each(:,:,i) = a;
    end
end