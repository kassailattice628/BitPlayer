function roi_sort = Sort_ROI_by_DSOS(im, type)
%
% to show 2D color map
% ex)
% sortby = im.Ang_DS

switch type
    case 'DS'
        %%%% Sort order %%%%
        %roi_res
        % -roi_positive
        %  --roi_DS_ppsitive sort by Ang_DS
        % -roi_non_DS_positive
        %
        % -roi_negative
        %  --roi_DS_negative sort by Ang_DS
        % -roi_non_DS_negative
        %roi_no-res

        %check the ROI inclueded in both positive/negatives
        [~, ia] = intersect(im.roi_DS_positive, im.roi_DS_negative);
        if ~isempty(ia)
            im.roi_DS_negative(ia) = [];
        end

        roi1 = im.roi_DS_positive;
        roi2 = setdiff(im.roi_positive, roi1);
        roi3 = im.roi_DS_negative;
        roi4 = setdiff(im.roi_negative, roi3);
        roi5 = im.roi_nores;
        %check
        a = [roi1, roi2, roi3, roi4, roi5];
        if length(a)~=im.Num_ROIs
            errordlg('Size of ROIs and sorted ROIs is differet!')
        end
        A = im.Ang_DS;

    case'OS'

        %check the ROI inclueded in both positive/negatives
        [~, ia] = intersect(im.roi_OS_positive, im.roi_OS_negative);
        if ~isempty(ia)
            im.roi_OS_negative(ia) = [];
        end
        roi1 = im.roi_OS_positive;
        roi2 = setdiff(im.roi_positive, roi1);
        roi3 = im.roi_OS_negative;
        roi4 = setdiff(im.roi_negative, roi3);
        roi5 = im.roi_nores;
        %check
        a = [roi1,roi2, roi3, roi4, roi5];
        if length(a)~=im.Num_ROIs
            errordlg('Size of ROIs and sorted ROIs is differet!')
        end
        A = im.Ang_OS;
end

% Joint roi orders.

[~, i1] = sort(A(1, roi1));
[~, i2] = sort(A(1, roi2));
[~, i3] = sort(A(2, roi3));
[~, i4] = sort(A(2, roi4));
[~, i5] = sort(A(1, roi5));
roi_sort = [roi1(i1), roi2(i2), roi3(i3), roi4(i4), roi5(i5)];

%im.mat2D_sort = im.mat2D(im.roi_sort_DS, :);




end