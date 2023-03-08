function im = Transform_dFF_stim_average(im)
%
%
%mat = im.dFF_stim_average;
%
%
mat = im.dFF_stim_average;
% Transform matrix
MAT = zeros(size(mat, 3), size(mat,1)*size(mat,2));
for roi = 1:size(mat,3)
    a = mat(:,:, roi);
    a = reshape(a, [1, size(mat,1)*size(mat,2)]);
    MAT(roi, :) = a;
end
im.mat2D = MAT;



end