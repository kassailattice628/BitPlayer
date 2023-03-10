function Run_Bootstrap(app)
%
% 
%

%rng(6281980)
im = app.imgobj;
s = app.sobj;
im.n_bstrp = app.n_bootstrp.Value;

%% Show progress bar
% f = uifigure;
% d = uiprogressdlg(f, 'Title', 'Bootstrapping data',...
%     'Indeterminate', 'on');

%%
switch s.Pattern
    case {'Moving Bar', 'Shifting Grating'}

        %%% DS %%%
        [P, dFF_peak_btsrp] = Bootstrap_DSI_OSI(im, 'Direction');
        P_shuffled = Bootstrap_DSI_OSI(im, 'Direction', 1);

        %compare DSI vs DSI_shuffle and define selective ROI.
        %im.roi_DS_positive = *******+
        roi_DS = [];
        for roi = 1:im.Num_ROIs
            % 5% shuffled DSI < DSI
            if sum(P(:, 1, roi) < P_shuffled(:, 1, roi))/im.n_bstrp < 0.05
                roi_DS = [roi_DS, roi];
            end
        end

        im.L_DS_bstrp = squeeze(P(:,1,:));
        im.Ang_DS_bstrp = squeeze(P(:,2,:));
        im.dFF_peak_btsrp = dFF_peak_btsrp;

        %%% OS %%%
        [P, dFF_peak_btsrp] = Bootstrap_DSI_OSI(im, 'Orientation');
        P_shuffled = Bootstrap_DSI_OSI(im, 'Orientation', 1);

        roi_OS = [];
        for roi = 1:im.Num_ROIs
            % 5% shuffled OSI < OSI
            if sum(P(:, 1, roi) < P_shuffled(:, 1, roi))/im.n_bstrp < 0.05
                roi_OS = [roi_OS, roi];
            end
        end

        im.L_OS_bstrp = squeeze(P(:,1,:));
        im.Ang_OS_bstrp = squeeze(P(:,2,:));
        im.dFF_peak_btsrp_orientation = dFF_peak_btsrp;


        %Update selective ROI
        im.roi_DS_positive = roi_DS;
        im.roi_OS_positive = roi_OS;
        im.roi_non_selective = setdiff(im.roi_res, union(roi_DS, roi_OS));
        %ROI_sorted
        im.roi_sort(1,:) = Sort_ROI_by_DSOS(im, 'DS');
        im.roi_sort(2,:) = Sort_ROI_by_DSOS(im, 'OS');
        %%%%%%%%%%

    case {'Moving Spot', 'Sinusoidal', 'Gabor'}

        % Force recalcurate bootstrap if checkbox is ON
        if ~isfield(im, 'Params_boot') || app.newbootstrapCheckBox.Value
            disp('Bootstrapping...')
            %
            % To find selectivec cells, DSI/OSI are compared with
            % shuffled DSI/OSI, rather than using threshold
            %

            im = Get_Boot_DSI_OSI(im, n_bootstrap);

            % Reget stim average
            % Get_Trial_Averages(app, 0);
            im = Get_mat2D(im, s);
            app.imgobj = im;
            Plot_All_Averages(app, -1, 1);



        else
            %Plot only
            errordlg('Already calculated.')
        end

    case 'StaticBar'
        if ~isfield(im, 'P_boot')
            disp('Bootstrapping...')

            [R_boot_med, P_boot, roi_os, b_os, Ci_os, f_os] =...
                Get_Boot_BarOS(im);

            im.dFF_boot_med = R_boot_med;
            im.P_boot = P_boot;
            im.f_os = f_os;
            im.roi_os = roi_os;
            im.b_os = b_os;
            im.Ci_os = Ci_os;

        else
            %Plot only
            errordlg('Already calculated.')
        end

    case {'Uni', 'FineMap'}
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
end
%% Update imgobj

im.bstrpDone = true;
app.imgobj = im;


end