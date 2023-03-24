function d_out = Transform_D2O(data)
%
% Transform Matrix for moving bar/Grating 
% into bar orientation matrix.
%
d_out = zeros(size(data,1)* 2, size(data,2)/2, size(data, 3));
n_stim = size(data, 2);

for i = 1:size(data, 3) % by each roi
    d_out(:,:, i) = [data(:, 1:n_stim/2, i); data(:, (n_stim/2 + 1): end, i)];
end

end