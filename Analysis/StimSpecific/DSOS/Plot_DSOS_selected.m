function Plot_DSOS_selected(im)
%
% Plot tuning of selected ROI
%

switch isfield(im, 'P_boot')
    case 1

    case 0

        for roi = im.selected_ROIs
            Plot_DSOS(im, im.stim_directions, roi, 'DS')

        end
end
end