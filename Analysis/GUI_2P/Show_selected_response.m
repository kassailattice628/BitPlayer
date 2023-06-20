function Show_selected_response(app)
%
%
%
im = app.imgobj;
s = app.sobj;

%%
for i = im.selected_ROIs

    switch app.sobj.Pattern
        case 'Uni'

            divnum = s.DivNum;
            Plot_on_stim_location(i, im, divnum, app.Zscore.Value);
        case 'Fine Mapping'

            divnum = s.Div_grid;

            
            Plot_on_stim_location(i, im, divnum, app.Zscore.Value);

        otherwise
            Plot_stacked_time_series(i, im, app.Zscore.Value);
    end

end
end

%% Sub function for plot selected ROI
%%
function Plot_on_stim_location(i, im, divnum, Z)

Y = im.dFF_stim_average(:,:,i);

%%%%%%%%%%%%%%%%%%%%%%
% traces in  2D matrix
%%%%%%%%%%%%%%%%%%%%%%
figure
tlo = tiledlayout(divnum, divnum);
tlo.Padding = 'compact';
tlo.TileSpacing = 'none';

y1 = min(min(Y));
y2 = max(max(Y));
if y1 < -2
    y1 = -2;
end

tile_order = reshape(1:divnum^2, divnum, divnum);
tile_order = reshape(tile_order', 1, divnum^2);
for n = tile_order
    ax = nexttile(tlo);
    plot(ax, Y(:, n));
    ax.XAxis.Visible = 'off';
    ax.YAxis.Visible = 'off';
    ylim([y1, y2])
end

title(tlo, ['ROI: #', num2str(i)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Color Map in 2D stim location 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
% reshape Y
Y_reshape = zeros(divnum, size(Y,1)*divnum);

for n1 = 1:divnum

    Y_sub = [];
    for n2 = 1:divnum
        n3 = n1+divnum*(n2-1);
        %n3 = tile_order(n1+divnum*(n2-1));
        Y_sub = [Y_sub, Y(:,n3)'];
    end

    Y_reshape(n1, :) = Y_sub;
end

imagesc(Y_reshape)
%%% Color range %%%%%
if Z
    clim([-2, 8]);
else
    clim([-1, 5]);
end

end

%%
function Plot_stacked_time_series(i, im, Z)
Y = im.dFF_stim_average(:,:,i);
T = (0:size(Y,1)-1)*im.FVsampt;

%stim onset
on = im.p_prestim + 1;
%stim onset
off = im.p_prestim + im.p_stim + 1;

figure
tiledlayout(2,2);

%%%%%%%%%%%%%%%%%%%%%%
% Stacked dF/F traces
%%%%%%%%%%%%%%%%%%%%%%
nexttile([2,1])
hold on
for i2 = 1:size(Y,2)
    Y(:,i2) = Y(:,i2) + (i2-1)*2*im.SD(:,i);
    plot(T, Y(:,i2), 'b-')
end
line([T(on), T(on)], [min(Y(:,1)), max(Y(:,i2))*1.1], 'Color', 'r', 'LineWidth', 1)
line([T(off), T(off)], [min(Y(:,1)),max(Y(:,i2))*1.1], 'Color', 'r', 'LineWidth', 1)
hold off
title(['ROI# ', num2str(i)])
xlabel('Time (s)')
xlim([T(1), T(end)])
ylabel('dF/F, Stim#')
%ylim([min(Y(:,1), 'omitnan'), max(Y(:,i2), 'omitnan')*1.1])


%%%%%%%%%%%%%%%%%%%%%%
% Color map
%%%%%%%%%%%%%%%%%%%%%%
nexttile([2, 1])
Y = im.dFF_stim_average(:,:,i);
img_x = 1:size(Y, 2);

imagesc(T, img_x, Y')
if Z
    clim([-4, 15]);
else
    clim([-1, 5]);
end

line([T(on), T(on)], [0, size(Y,2)+0.5], 'Color', 'w', 'LineWidth', 1)
line([T(off), T(off)], [0, size(Y,2)+0.5], 'Color', 'w', 'LineWidth', 1)

ylabel('Stim#')
xlabel('Time (s)')
axis xy % Up-side down image.
end