function Set_RandChecker2(app)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate Checker Matrix
% original Set_RandCher specified patch area and set each pixes to w/b.
% Each patch is prepared as 2x2 checkerboard, white or black matrix.
% Center pixes of each panels are calculated and put panels on each
% position.
% 
% Decode SC/test v3
% 20240313
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sobj = app.sobj;

% Prepare patch (128x128)
patch_white = uint8(ones(32,32));
patch_black = uint8(zeros(32,32));
p1 = [patch_white, patch_black, patch_white, patch_black];
p2 = [patch_black, patch_white, patch_black, patch_white];
patch_checker = [p1;p2;p1;p2];

sobj.patch_white = repmat(patch_white, 4, 4);
sobj.patch_checker = patch_checker;


% Define stim area (sobj.Distance:60 deg -> variable)
disp(sobj.Distance)
Area_deg = [0, 0, sobj.Distance, sobj.Distance];
Area_pix = Deg2Pix(Area_deg, sobj.MonitorDist, sobj.Pixelpitch);
Pos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
C = Pos_list(sobj.FixPos, :);
Area = CenterRectOnPointd(Area_pix, C(1), C(2));

%{
%　Caclulate Center position of each patch.
patch = round(Area_pix(3) / sobj.Div_grid);
patch_left = ceil(Area(1)) + round(Area_pix(3)/2);
patch_h = patch_left + patch .* (1:sobj.Div_grid);

patch_top = ceil(Area(3)) + round(Area_pix(3)/2);
patch_v = patch_top + patch .* (1:sobj.Div_grid);

[x, y] = meshgrid(patch_h, patch_v);
x = reshape(x, [], 1);
y = reshape(y, [], 1);
sobj.Checker_patch_centerX = x;
sobj.Checker_patch_centerY = y;
%}

%% Generate Checker RECTs
[x, y] = meshgrid(1:sobj.Div_grid, 1:sobj.Div_grid);
x = reshape(x, [], 1);
y = reshape(y, [], 1);

X_panel = linspace(Area(1), Area(3), sobj.Div_grid + 1);
X_panel = reshape(X_panel, [], 1);
Y_panel = linspace(Area(2), Area(4), sobj.Div_grid + 1);
Y_panel = reshape(Y_panel, [], 1);

Checker_left = X_panel(1:end-1);
Checker_right = X_panel(2:end);
Checker_top = Y_panel(1:end-1);
Checker_bottom = Y_panel(2:end);

Checker_RECT = zeros(4, sobj.Div_grid^2); %Left, Top, Right, Bottom
Checker_RECT(1,:) = Checker_left(x);
Checker_RECT(2,:) = Checker_top(y);
Checker_RECT(3,:) = Checker_right(x);
Checker_RECT(4,:) = Checker_bottom(y);
sobj.Checker_RECT = Checker_RECT;

%%
app.sobj = sobj;

end