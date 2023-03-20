function mat2D = Transform_dFF_stim_average(im, os)
%
%
%mat = im.dFF_stim_average;
%
%

if nargin == 1
    os = 0;
end

if os == 0
    mat = im.dFF_stim_average;
elseif os
    mat = im.dFF_stim_average_orientation;
end

% Transform matrix
mat2D = zeros(size(mat, 3), size(mat,1)*size(mat,2));
for roi = 1:size(mat,3)
    a = mat(:,:, roi);
    a = reshape(a, [1, size(mat,1)*size(mat,2)]);
    mat2D(roi, :) = a;
end

%im.mat2D = mat2D;

end