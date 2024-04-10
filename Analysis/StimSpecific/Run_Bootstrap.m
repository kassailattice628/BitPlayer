function Run_Bootstrap(app)
%%%%%%%%%%%%%%%%%%%
%
% Resample data and estimat fit.
% For MovingBar & Grating:: VonMises.
% Uni & Fine Mapping:: 2D Gaussian with rotation.
%
%%%%%%%%%%%%%%%%%%%

%rng(6281980)
im = app.imgobj;
s = app.sobj;
im.n_bstrp = app.n_bootstrp.Value;

% Show progress bar
% f = uifigure;
% d = uiprogressdlg(f, 'Title', 'Bootstrapping data',...
%     'Indeterminate', 'on');

%% Stimulus specific condition
switch s.Pattern
    case {'Moving Bar', 'Shifting Grating'}

        % Generate bootstrapped data
        [P_DS, P_OS, d_bstrp_ds, d_bstrp_os] = ...
            Bootstrap_DSI_OSI(im, 0);

        % with shuffling
        [P_DS_shuffle, P_OS_shuffle, ~] = ...
            Bootstrap_DSI_OSI(im, 1);


        %test plot
        %{
        n = 5;
        rois = [10	16	20	23	32];
        figure
        for i = 1:n
            roi = rois(i);
            subplot(n, 1, i)
            h1 = histogram(P_OS(:,1, roi));
            h1.Normalization = 'probability';
            h1.BinWidth = 0.01;
            hold on
            h2 = histogram(P_OS_shuffle(:,1, roi));
            h2.Normalization = 'probability';
            h2.BinWidth = 0.01;
            title(['ROI:', num2str(roi)])
        end
        %}

        % Update ROI DS/OS
        roi_DS = [];
        roi_OS = [];

        for roi = 1:im.Num_ROIs
            % 5% shuffled DSI < DSI
            if sum(P_DS(:, 1, roi) < P_DS_shuffle(:, 1, roi))/size(P_DS, 1)...
                    < 0.05 &&...
                    ~ismember(roi, im.roi_nores)
                roi_DS = [roi_DS, roi];
            end
            
            if sum(P_OS(:, 1, roi) < P_OS_shuffle(:, 1, roi))/size(P_OS, 1)...
                    < 0.05 &&...
                    ~ismember(roi, im.roi_nores)
                roi_OS = [roi_OS, roi];
            end
        end


        %% DS
        % Save median of L(DSI/OSI) and 95% range.
        L = squeeze(P_DS(:,1,:));
        im.L_DS_bstrp = Get_Median_95Rabge(L);
        Ang = squeeze(P_DS(:,2,:));
        im.Ang_DS_bstrp = Get_Median_95Rabge(Ang);
        im.dFF_peak_btsrp_direction = Get_Median_95Rabge(d_bstrp_ds);

        %% OS
        L = squeeze(P_OS(:,1,:));
        im.L_OS_bstrp = Get_Median_95Rabge(L);
        Ang = squeeze(P_OS(:,2,:));
        im.Ang_OS_bstrp = Get_Median_95Rabge(Ang);
        im.dFF_peak_btsrp_orientation = Get_Median_95Rabge(d_bstrp_os);

        %% Update selective ROI
        im.roi_DS_positive = roi_DS;
        im.roi_OS_positive = roi_OS;
        im.roi_non_selective = setdiff(im.roi_res, union(roi_DS, roi_OS));
        
        %% ROI_sorted

        im.roi_sortDS = Sort_ROI_by_DSOS(im, 'DS');
        im.roi_sortOS = Sort_ROI_by_DSOS(im, 'OS');

        %% Fit vonMises
        disp('Fitting data...')
        beta_ = zeros(im.Num_ROIs, 6);
        Ci_ = zeros(im.Num_ROIs, 6 * 2);

        R_ = cell(1, im.Num_ROIs);

        Ja_ = cell(1, im.Num_ROIs);

        f_select_ = zeros(1, im.Num_ROIs);

        %% Define VM functions (single or double)
        %single peak
        F_VM1 = @(b, x) b(1) * exp(b(2) * cos(x - b(3))) + b(4);

        %double peak
        F_VM2 = @(b, x) b(1) * exp(b(2) * cos(x - b(5))) .*...
                exp(b(3) * cos(2*x - 2*(b(5)+b(6)))) + b(4);

        %% Fit VM for selective cells
        rois = union(roi_DS, roi_OS);
        directions = im.stim_directions;
        Ang_DS = im.Ang_DS_bstrp(1,:);

        for i = 1:length(rois)
            roi = rois(i);
            [beta, ci, f_select, R, Ja] = ...
                Fit_vonMises(d_bstrp_ds(:,:, roi), directions,...
                Ang_DS(roi), F_VM1, F_VM2);

            beta_(roi,:) = beta;
            Ci_(roi, :) = ci;
            f_select_(roi) = f_select;
            R_{roi} = R;
            Ja_{roi} = Ja;
            fprintf('Fit vonMises ROI#%d\n', roi)
        end

        im.fit.beta = beta_;
        im.fit.Ci = Ci_;
        im.fit.f_select = f_select_;
        im.fit.R = R_;
        im.fit.Ja = Ja_;

        disp('Done.')
        
        %%%%%%%%%%

    case {'Uni', 'Fine Mapping'}

        % Generate bootstrapped data: [n_bstrp, n_stim, n_ROIs]
        data_bstrp = Bootstrap_RF(im, 0);

        b_GaussianRot2D = zeros(im.Num_ROIs, 6);
        R2 = zeros(im.Num_ROIs, 1);

        %i_ROI = 64;
        for i_ROI = 1:im.Num_ROIs
            [b_GaussianRot2D(i_ROI, :), R2(i_ROI,1)] =...
                Find_RF_fit(data_bstrp(:,:,i_ROI), s);
        end

        im.beta_GRot2D = b_GaussianRot2D;
        im.beta_R2 = R2;


        % Check result
        check_flag = 0;
        if check_flag
            n_grid = sqrt(size(data_bstrp, 2));

            data = data_bstrp(:,:,i_ROI);
            data = mean(data, 'omitnan');
            data = reshape(data, [n_grid, n_grid]);

            %
            X_grid = linspace(1, n_grid, 100);
            [X, Y] = meshgrid(X_grid, X_grid);
            XY_grid(:,:,1) = X;
            XY_grid(:,:,2) = Y;
            RF2DRot = GaussianRot2D(b_GaussianRot2D(i_ROI,:), XY_grid);

            %Elipse
            [x_e, y_e] = RF_Elipse(b_GaussianRot2D(i_ROI,:));


            figure
            tiledlayout(1,2)
            nexttile;
            imagesc([1, n_grid], [1, n_grid], data)
            hold on
            plot(x_e, y_e, 'r', 'LineWidth',2)
            title('RAW(mean)')

            nexttile;
            imagesc([min(X_grid), max(X_grid)], [min(X_grid), max(X_grid)], RF2DRot)
            hold on
            plot(x_e, y_e, 'r', 'LineWidth',2)
            title('Fit')
        end

        %{
      
        if ~isfield(im, 'dFF_boot_med')
             [R_boot_med, b_GaRot2D, Ci_GaRot2D, b_Ellipse] = ...
                Get_Boot_RF(app); %im

            im.dFF_boot_med = R_boot_med;
            im.b_GaRot2D = b_GaRot2D;
            im.Ci_GaRot2D = Ci_GaRot2D;
            im.b_Ellipse = b_Ellipse;

            %plot だけ分けたいが
        else
            %Plot only
            i_roi = 1:im.maxROIs;
            i_roi = i_roi(im.b_GaRot2D(:,1) >= 0.15);
            if ~isempty(check_box)
                if app.plotCheckBox.Value
                    Plot_RF_selected(i_roi);
                end
            end
        end
        %}

%%

    case {'Moving Spot', 'Sinusoidal', 'Gabor'}

    case 'StaticBar'
end
%% Update imgobj

im.bstrpDone = true;
app.Bootstrap.BackgroundColor = [1, 0.81, 0.81];

app.imgobj = im;


end