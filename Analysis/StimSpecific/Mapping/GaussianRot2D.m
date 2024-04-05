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
% XY(:,:,1) = X; XY(:,:,2) = Y;
%
%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%%

X = XY(:,:,1);
Y = XY(:,:,2);

f = beta(1) * exp(...
    -( (cos(beta(6)) * (X - beta(2)) + sin(beta(6)) * (Y - beta(4))).^2 / (2*beta(3)^2)) +...
    -( (-sin(beta(6)) * (X - beta(2)) + cos(beta(6)) * (Y - beta(4))).^2 / (2*beta(5)^2))...
    );


%{
% Rotation correction
Xrot = X.* cos(beta(6)) - Y.* sin(beta(6));
Yrot = X.* sin(beta(6)) + Y.* cos(beta(6));

% Center correction
X0rot = beta(2) * cos(beta(6)) - beta(4) * sin(beta(6));
Y0rot = beta(2) * sin(beta(6)) + beta(4) * cos(beta(6));

% 2D Gaussian wit correction
f = beta(1) *exp(...
    -((Xrot - X0rot).^2 / (2*beta(3)^2))...
    -((Yrot - Y0rot).^2 / (2*beta(5)^2))...
    );

%}

end