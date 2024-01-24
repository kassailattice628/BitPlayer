%%%%%% Comaring two (or several daq files)
clear

f1 = load('/home/lattice/Share/s2p_working/20230512daq/1402/daq_2_.mat',...
    'sobj', 'imgobj');

f2 = load('/home/lattice/Share/s2p_working/20230512daq/1402/daq_3_.mat',...
    'sobj', 'imgobj');


%%
roi_all = 1:f1.imgobj.Num_ROIs;

% Use positive response properties now...
roi_DS = intersect(f1.imgobj.roi_DS(1,:), f2.imgobj.roi_DS(1,:));
roi_notDS = setdiff(roi_all, roi_DS(1,:));
roi_OS = intersect(f1.imgobj.roi_OS(1,:), f2.imgobj.roi_OS(1,:));
roi_notOS = setdiff(roi_all, roi_OS(1,:));

%%
%diff_ang = f1.imgobj.Ang_DS(1,:) - f2.imgobj.Ang_DS(1,:);

figure,
tiledlayout(2,2)

nexttile
plot(f1.imgobj.L_DS(1, roi_DS), f2.imgobj.L_DS(1, roi_DS), 'o');
hold on
line([0,1], [0,1])
title('DS')
xlabel('pre')
ylabel('post')

nexttile
plot(f1.imgobj.L_OS(1, roi_OS), f2.imgobj.L_OS(1, roi_OS), 'o');
hold on
line([0,1], [0,1])
title('OS')
xlabel('pre')
ylabel('post')

nexttile
plot(f1.imgobj.Ang_DS(1, roi_DS), f2.imgobj.Ang_DS(1, roi_DS), 'o');
hold on
title('Direction')
xlabel('pre')
ylabel('post')

nexttile
plot(f1.imgobj.Ang_OS(1, roi_OS), f2.imgobj.Ang_OS(1, roi_OS), 'o');
hold on
title('Orientation')
xlabel('pre')
ylabel('post')
%%
figure
tiledlayout(1,2)

nexttile
plot(f1.imgobj.Ang_DS(1, roi_DS), f2.imgobj.Ang_DS(1, roi_DS), '.');
hold on
plot(f1.imgobj.Ang_DS(1, roi_notDS), f2.imgobj.Ang_DS(1, roi_notDS), '.');
xlim([0,2*pi])
xlabel('AngDS1')
ylim([0, 2*pi])
ylabel('AngDS2')

nexttile
plot(f1.imgobj.Ang_OS(1,roi_OS), f2.imgobj.Ang_OS(1,roi_OS), '.');
hold on
plot(f1.imgobj.Ang_OS(1, roi_notOS), f2.imgobj.Ang_OS(1,roi_notOS), '.');
xlim([-pi/2, pi/2])
xlabel('AngOS1')
ylim([-pi/2, pi/2])
ylabel('AngOS2')

%%

for i = roi_OS %union(roi_notDS, roi_notOS)
%for i = 6:9
    Z = true;
    figure
    tiledlayout(1,2)
    nexttile
    Y = f1.imgobj.dFF_stim_average(:,:,i);
    T = (0:size(Y,1)-1)*f1.imgobj.FVsampt;
    img_x = 1:size(Y, 2);

    imagesc(T, img_x, Y')
    if Z
        clim([-4, 15]);
    else
        clim([-1, 5]);
    end

    %line([T(on), T(on)], [0, size(Y,2)+0.5], 'Color', 'w', 'LineWidth', 1)
    %line([T(off), T(off)], [0, size(Y,2)+0.5], 'Color', 'w', 'LineWidth', 1)
    title(['f1', ' L=', num2str(f1.imgobj.L_OS(1,i))])
    ylabel('Stim#')
    xlabel('Time (s)')
    axis xy % Up-side down image.


    nexttile
    Y = f2.imgobj.dFF_stim_average(:,:,i);
    img_x = 1:size(Y, 2);

    imagesc(T, img_x, Y')
    if Z
        clim([-4, 15]);
    else
        clim([-1, 5]);
    end

    %line([T(on), T(on)], [0, size(Y,2)+0.5], 'Color', 'w', 'LineWidth', 1)
    %line([T(off), T(off)], [0, size(Y,2)+0.5], 'Color', 'w', 'LineWidth', 1)
    title(['f2', ' L=', num2str(f2.imgobj.L_OS(1,i))])
    ylabel('Stim#')
    xlabel('Time (s)')
    axis xy % Up-side down image.
end


%%
