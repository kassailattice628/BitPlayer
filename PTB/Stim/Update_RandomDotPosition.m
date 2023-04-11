function [xy, cs, theta, r] = Update_RandomDotPosition(xy, cs, theta, r, R_max, f_kill)
%
% Update position of random dots
%



% Check if the position is inside R_max
% and randomly select regenerate dots
i_warp = find(r > R_max | rand(size(xy, 1), 1) < f_kill);
n_out = length(i_warp);

if n_out
    %new cordinate
    r(i_warp) = R_max * sqrt(rand(n_out, 1));
    theta(i_warp) = 2*pi * rand(n_out, 1);
    cs(i_warp, :) = [cos(theta(i_warp)), sin(theta(i_warp))];
    xy(i_warp, :) = [r(i_warp), r(i_warp)] .* cs(i_warp,:);
end

end