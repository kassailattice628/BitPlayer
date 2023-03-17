function roi_sort = Sort_ROI_by_DSOS(im, type)
%
% to show 2D color map
% ex)
% sortby = im.Ang_DS


roi_sort = zeros(2, im.Num_ROIs); %for positive and negative


switch type
    case 'DS'
        %%%% Sort order %%%%
        %roi_res
        % -roi_positive
        %  --roi_DS_ppsitive sort by Ang_DS
        %  --roi_non_DS_positive
        %
        % -roi_negative
        %  --roi_DS_negative sort by Ang_DS
        %  --roi_non_DS_negative
        %
        %roi_no-res


        %Sorted based on positive responses
        roi1 = im.roi_DS_positive;
        roi2 = setdiff(im.roi_positive, roi1); %non-selective for positive
        % Remove overlapped ROIs from negative ROIs
        [~, ia]= intersect(im.roi_negative, im.roi_positive);
        roi_3 =  im.roi_negative; % negative
        roi_3(ia) = [];
        % Update DS negative
        [roi3, ia] = intersect(roi_3, im.roi_DS_negative);
        % Remaining are non-selevtive negative;
        roi4 = im.roi_negative;
        roi4(ia) = [];
        roi5 = im.roi_nores;
%         %check
%         a1 = [roi1, roi2, roi3, roi4, roi5];
%         if length(a1)~=im.Num_ROIs
%             errordlg('Size of ROIs and sorted ROIs is differet!')
%         end

        % Angles
        A = im.Ang_DS;
        roi_sort(1,:) = Sort_ROIs(A, 'positive', roi1, roi2, roi3, roi4, roi5);

        % Negative
        roi1 = im.roi_DS_negative;
        roi2 = setdiff(im.roi_negative, roi1); %non-selective for negative
        %remove overlapped from negative ROIs
        [~, ia]= intersect(im.roi_positive, im.roi_negative);
        roi_3 =  im.roi_positive; % negative
        roi_3(ia) = [];
        roi3 = intersect(im.roi_DS_positive, roi_3); % negative + DS_negative;
        roi4 = setdiff(im.roi_positive, roi3); %non-selective for negative
        roi5 = im.roi_nores;
%         %check
%         a2 = [roi1, roi2, roi3, roi4, roi5];
%         if length(a2)~=im.Num_ROIs
%             errordlg('Size of ROIs and sorted ROIs is differet!')
%         end

        roi_sort(2, :) = Sort_ROIs(A, 'negative', roi1, roi2, roi3, roi4, roi5);


    case'OS'

        %Sorted based on positive responses
        roi1 = im.roi_OS_positive;
        roi2 = setdiff(im.roi_positive, roi1); %non-selective for positive
        % Remove overlapped ROIs from negative ROIs
        [~, ia]= intersect(im.roi_negative, im.roi_positive);
        roi_3 =  im.roi_negative; % negative
        roi_3(ia) = [];
        % Update DS negative
        [roi3, ia] = intersect(roi_3, im.roi_OS_negative);
        % Remaining are non-selevtive negative;
        roi4 = im.roi_negative;
        roi4(ia) = [];
        roi5 = im.roi_nores;

        % Angles
        A = im.Ang_OS;
        roi_sort(1,:) = Sort_ROIs(A, 'positive', roi1, roi2, roi3, roi4, roi5);

        % Negative
        roi1 = im.roi_OS_negative;
        roi2 = setdiff(im.roi_negative, roi1); %non-selective for negative
        %remove overlapped from negative ROIs
        [~, ia]= intersect(im.roi_positive, im.roi_negative);
        roi_3 =  im.roi_positive; % negative
        roi_3(ia) = [];
        roi3 = intersect(im.roi_OS_positive, roi_3); % negative + DS_negative;
        roi4 = setdiff(im.roi_positive, roi3); %non-selective for negative
        roi5 = im.roi_nores;
        roi_sort(2, :) = Sort_ROIs(A, 'negative', roi1, roi2, roi3, roi4, roi5);
end



end

%% Select positive/negative responses
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