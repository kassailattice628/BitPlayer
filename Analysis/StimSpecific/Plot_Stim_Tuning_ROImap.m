function Plot_Stim_Tuning_ROImap(app)
%
% Stim tuning is refleced into the ROI position
%

im = app.imgobj;
s = app.sobj;
%% Histogram of tuning properties
switch s.Pattern
    case {'Moving Bar', 'Moving Spot'}
        %nbins = 24;
        %roi = im.roi_res;

        roi_ds = im.roi_DS_positive;
        roi_os = im.roi_OS_positive;

        %%%%%%%%%% Orientation Selectivity %%%%%%%%%%
        figure
        subplot(2, 3, 1)
        histo_plot(im.L_OS(roi_os), 'L_OS');

        subplot(2, 3, 2)
        histo_plot(im.Ang_OS(roi_os), 'Ang_OS');

        subplot(2, 3, 3)
        plot(im.Ang_OS(roi_os), im.L_OS(roi_os), 'bo')
        title('Pref Orientation vs OSI')
        xlim([-pi/2, pi/2])

        %%%%%%%%%% Direction Selectivity %%%%%%%%%%
        subplot(2, 3, 4)
        histo_plot(im.L_DS(roi_ds), 'L_DS');

        subplot(2, 3, 5)
        histo_plot(im.Ang_DS(roi_ds), 'Ang_DS');

        subplot(2, 3, 6)
        plot(im.Ang_DS(roi_ds), im.L_DS(roi_ds), 'bo')
        title('Pref Direction vs DSI')
        xlim([0, 2*pi])

end

end

%%%%%
function histo_plot(d, option)
switch option
    case 'Ang_DS'
    bins = 0: pi/12 : 2*pi;
    ticks = [0, pi/2, pi, 3*pi/2, 2*pi];
    labels = {'0', 'pi/2', 'pi', '3pi/2', '2pi'};
    lims = [0, 51/24*pi];
    txt = 'Direction';

    case 'Ang_OS'
    bins = -pi/2 : pi/24 : pi/2;
    ticks = [-pi/2, 0, pi/2];
    labels = {'-pi/2', '0', 'pi/2'};
    lims = [-pi/2, pi/2];
    txt = 'Orientation';

    case {'L_OS', 'L_DS'}
        bins = 0: 0.025: 1;
        ticks = [0, 0.15, 0.2, 0.5, 1];
        labels = {'0', '0.15', '0.2', '0.5', '1'};
        lims = [0, 1];
        txt = 'Selectivity Index';
end

h_dir = histogram(d);
h_dir.BinEdges = bins;

xlim(lims)
xticks(ticks);
xticklabels(labels)
title(txt);
end