function f = GaussianRot2D(beta, XY)
%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%%
%
% Estimating six parameters (beta) of a 
% 2D Gaussian function with rotation.
%
% beta: [Amp, x0, x_sd, y0, y_sd, phi]
% XY: xy grid data, for example,
% x = linspace(0,10,100); y = linspace(0,10,100)
% [X,Y] = meshgrid(x, y);
%
%
%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%%

if size(XY,3) == 2
    X = XY(:,:,1);
    Y = XY(:,:,2);

elseif size(XY,3) == 1
    X = XY(:,1);
    Y = XY(:,2);
end


f = beta(1) * exp(...
    -( (cos(beta(6)) * (X - beta(2)) + sin(beta(6)) * (Y - beta(4))).^2 / (2*beta(3)^2)) +...
    -( (-sin(beta(6)) * (X - beta(2)) + cos(beta(6)) * (Y - beta(4))).^2 / (2*beta(5)^2))...
    );


end