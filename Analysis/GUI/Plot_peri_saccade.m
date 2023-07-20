function Plot_peri_saccade(mat1v, mat2v, mat1h, mat2h, t_plot)

%t_plot = -0.1:1/sf:0.1;

mat1v_ = apply_mean(mat1v, length(t_plot));
mat2v_ = apply_mean(mat2v, length(t_plot));
mat1h_ = apply_mean(mat1h, length(t_plot));
mat2h_ = apply_mean(mat2h, length(t_plot));

a1 = 0.2;
a2 = 1;
color_h = [0, 0.35, 1];
color_v = [1, 0.2, 0.2];
ylim_val = 0.25;
%%
figure
subplot(1,2,1)
plot(t_plot, mat1v_, 'Color', [color_h, a1]);
hold on
plot(t_plot, mat2v_, 'Color', [color_v, a1]);
plot(t_plot, mean(mat1v_), 'LineWidth', 3, 'Color', [color_h, a2]);
plot(t_plot, mean(mat2v_), 'LineWidth', 3, 'Color', [color_v, a2]);
title('Vertical saccade')
ylim([-ylim_val, ylim_val]);
xlabel('sec')
ylabel('Down < ----- > Up')

subplot(1,2,2)
plot(t_plot, mat1h_, 'Color', [color_h, a1]);
hold on
plot(t_plot, mat2h_, 'Color', [color_v, a1]);
plot(t_plot, mean(mat1h_), 'LineWidth', 3, 'Color', [color_h, a2]);
plot(t_plot, mean(mat2h_), 'LineWidth', 3, 'Color', [color_v, a2]);
xline(0, 'b-', {'Aligned by','30% rise time'})
title('Horizontal saccade')
ylim([-ylim_val, ylim_val]);
xlabel('sec')
ylabel('Temporal < ----- > Nasal')


%{
subplot(1,2,2)
for i = 1:size(mat2, 1)
    plot_data = mat2(i,:) - mean(mat2(i, 1:50));
    plot(t_plot, plot_data)
    hold on
end
%}

end

function mat = apply_mean(mat, l)

if ~isempty(mat)
    mat = mat - mean(mat(:, 1:50), 2);
else
    mat = zeros(l,1);
end
end