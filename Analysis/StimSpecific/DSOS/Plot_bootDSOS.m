function Plot_bootDSOS(f_vM, b_fit, d_vec, R_boot_med, roin, type, im)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% plot Bootstrapped data
% if the selected roi, defined in roin, have DS and/or OS
% vM fitted curve is superimposed
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%remove NaN from recorded data point
x = [];
y = [];

for j = 1:length(d_vec)
    for i = 1:size(im.dFF_s_each(:, j, roin), 1)
        y_ = im.dFF_s_each(i, j, roin);
        if ~isnan(y_)
            x = [x, d_vec(j)]; %#ok<*AGROW>
            y = [y, y_];
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set color
plot_fit = 0;

if isempty(type)
    
    if ismember(roin, im.roi_no_res)
        txt2 = 'No Responding';
        color = 'k';
        plot_fit = 0;
        
    elseif ismember(roin, im.roi_nega_R)
        txt2 = 'Negative Response';
        color = 'r';
        plot_fit = 0;
        
    else
        color = 'm';
        txt2 = 'Non selective';
        plot_fit = 0;
    end
    
elseif type == 1
    color = 'b';
    txt2 = 'Polar Distribution (DS)';
    plot_fit = 1;
    
elseif type == 2
    color = 'g';
    txt2 = 'Polar Distribution (OS)';
    plot_fit = 1;
end


%%%%%%%%%%%%%%%%%%%%


xp = 0:0.01:2*pi;

figure
%Raw plot
subplot(1,2,1)
hold on
%data mean
plot(x, y, [color, '.']);
%bootstrapped median
plot(d_vec, R_boot_med, [color, 'o'], 'MarkerSize', 7)

%fit
if plot_fit == 1
    
    plot_PredInt = 1;
    
    if plot_PredInt ==  1
        if type == 1 %DS
            [Ypred, delta] = nlpredci(f_vM, xp, b_fit, im.R_ds{roin}, 'Jacobian', im.J_ds{roin});
            
        elseif type == 2 %OS
            [Ypred, delta] = nlpredci(f_vM, xp, b_fit, im.R_os{roin}, 'Jacobian', im.J_os{roin});
        end
        
        boundedline(xp, Ypred, delta, 'alpha');
        
    elseif plot_PredInt == 2 %Plot Confidence Interval
        if type == 1
            if im.Ci_ds(roin, end) == 0
                nb = 8;
            else
                nb = 12;
            end
            b_u = im.Ci_ds(roin, 1:2:nb);
            b_l = im.Ci_ds(roin, 2:2:nb);
            y_u = f_vM(b_u, xp);
            y_l = f_vM(b_l, xp);
            
        elseif type == 2
            b_u = im.Ci_os(roin, 1:2:end);
            b_l = im.Ci_os(roin, 2:2:end);
            y_u = f_vM(b_u, xp);
            y_l = f_vM(b_l, xp);
        end
        
        plot(xp, f_vM(b_fit, xp), [color, '-'], 'LineWidth', 2);
        plot(xp, y_u, [color, '--'], 'LineWidth', 1);
        plot(xp, y_l, [color, '--'], 'LineWidth', 1);
        
    elseif plot_PredInt == 3
        if type == 1
            plot(im.FR_ds{roin}, 'predobs' );
        elseif type == 2
            plot(im.FR_os{roin}, 'predobs' );
        end
    end
    
    
end

xlim([-0.1, 2*pi+0.1])
title(['ROI# = ', num2str(roin)])
set(gca, 'xtick', [0, pi/2, pi, 3*pi/2, 2*pi],...
    'xticklabel', {'0', '\pi/2', '\pi', '3\pi/2', '2\pi'})
xlabel('Move Angle (deg)');

%Polar plot
subplot(1,2,2)
polar([d_vec, d_vec(1)], [R_boot_med, R_boot_med(1)], [color, 'o-']);
hold on;
title(txt2)