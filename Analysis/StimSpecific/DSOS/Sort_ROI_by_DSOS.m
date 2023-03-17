function roi_sort = Sort_ROI_by_DSOS(im, type)
%
% to show 2D color map
% ex)
% sortby = im.Ang_DS


roi_sort = zeros(2, im.Num_ROIs); %for positive and negative


switch type
    case 'DS'
        % Angles
        A = im.Ang_DS;

        %Positive
        [roi1, roi2, roi3, roi4] = Select_ROIs(...
            im.roi_positive, im.roi_DS_positive,...
            im.roi_negative, im.roi_DS_negative);
        roi_sort(1,:) = Sort_ROIs(A, 'positive', roi1, roi2, roi3, roi4,...
            im.roi_nores);
        
        %Negative
        [roi1, roi2, roi3, roi4] = Select_ROIs(...
            im.roi_negative, im.roi_DS_negative,...
            im.roi_positive, im.roi_DS_positive);
        roi_sort(2,:) = Sort_ROIs(A, 'positive', roi1, roi2, roi3, roi4,...
            im.roi_nores);

    case'OS'
        % Angles
        A = im.Ang_OS;
                %Positive
        [roi1, roi2, roi3, roi4] = Select_ROIs(...
            im.roi_positive, im.roi_OS_positive,...
            im.roi_negative, im.roi_OS_negative);
        roi_sort(1,:) = Sort_ROIs(A, 'positive', roi1, roi2, roi3, roi4,...
            im.roi_nores);
        
        %Negative
        [roi1, roi2, roi3, roi4] = Select_ROIs(...
            im.roi_negative, im.roi_OS_negative,...
            im.roi_positive, im.roi_OS_positive);
        roi_sort(2,:) = Sort_ROIs(A, 'positive', roi1, roi2, roi3, roi4,...
            im.roi_nores);
end



end

%%
function [roi1, roi2, roi3, roi4] = Select_ROIs(ROI1, ROI2, ROI3, ROI4)
        %%%% Sort order %%%%
        %roi_res
        % -roi_positive: ROI1
        %  --roi_DS_positive: ROI2
        %  --roi_non_DS_positive
        %
        % -roi_negative: ROI3
        %  --roi_DS_negative: ROI4
        %  --roi_non_DS_negative
        %
        %roi_no-res: ROI5

        %Sorted based on positive responses
        roi1 = ROI2;
        roi2 = setdiff(ROI1, roi1); %non-selective for positive
        % Remove overlapped ROIs from negative ROIs
        roi_neg= setdiff(ROI3, ROI1);
        roi3 = intersect(roi_neg, ROI4); %negative DS
        roi4 = setdiff(ROI3, roi3); %non-selective for negative

        %roi_sort = Sort_ROIs(A, 'positive', roi1, roi2, roi3, roi4, ROI5);

end
%% SORT BY PREF ANGLES
function roi_sort = Sort_ROIs(A, type, roi1, roi2, roi3, roi4, roi5)

if strcmp(type, 'positive')
    n1 = 1; %pos
    n2 = 2; %nega
elseif strcmp(type, 'negative')
    n1 = 2;
    n2 = 1;
end

% Sort by preferred angles and joint its orders.
[~, i1] = sort(A(n1, roi1));
[~, i2] = sort(A(n1, roi2));
[~, i3] = sort(A(n2, roi3));
[~, i4] = sort(A(n2, roi4));
[~, i5] = sort(A(n1, roi5));
roi_sort = [roi1(i1), roi2(i2), roi3(i3), roi4(i4), roi5(i5)];

end