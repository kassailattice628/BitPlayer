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
        tiledlayout(2,3)
        nexttile
        histo_plot(im.L_OS(1, roi_os), 'L_OS');

        nexttile
        histo_plot(im.Ang_OS(1, roi_os), 'Ang_OS');

        nexttile
        plot(im.Ang_OS(1, roi_os), im.L_OS(1, roi_os), 'bo')
        title('Pref Orientation vs OSI')
        xlim([-pi/2, pi/2])
        ticks = [-pi/2, 0, pi/2];
        labels = {'-pi/2', '0', 'pi/2'};
        xticks(ticks)
        xticklabels(labels)

        %%%%%%%%%% Direction Selectivity %%%%%%%%%%
        nexttile
        histo_plot(im.L_DS(1, roi_ds), 'L_DS');

        nexttile
        histo_plot(im.Ang_DS(1, roi_ds), 'Ang_DS');

        nexttile
        plot(im.Ang_DS(1, roi_ds), im.L_DS(1, roi_ds), 'bo')
        title('Pref Direction vs DSI')
        xlim([0, 2*pi])
        ticks = [0, pi/2, pi, 3*pi/2, 2*pi];
        labels = {'0', 'pi/2', 'pi', '3pi/2', '2pi'};
        xticks(ticks)
        xticklabels(labels)

    case 'Fine Mapping'
        % plot fitted 2D gaussian elipses (SD line)
        if isfield(im, 'beta_GRot2D')
            figure
            good_fit = find(im.beta_R2 > 0.3);
            for i = good_fit'
                [x, y] = RF_Elipse(im.beta_GRot2D(i,:));
                plot(x, y);
                hold on
            end
            xlim([1,9])
            ylim([1,9])
            axis ij

            figure
            x = linspace(1,9,50);
            [X,Y] = meshgrid(x,x);
            XY = [X(:), Y(:)];
            t = tiledlayout(7,7);
            t.TileSpacing = "compact";
            t.Padding = "compact";

            title(t, "Examples of fitted RF")

            i_max = min(49, length(good_fit));
            for i = 1:i_max
                R = GaussianRot2D(im.beta_GRot2D(good_fit(i),:), XY);
                nexttile
                imagesc([1,9],[1,9],reshape(R, 50, 50));
            end

        end

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