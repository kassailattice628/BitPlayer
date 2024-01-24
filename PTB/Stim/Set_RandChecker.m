function Set_RandChecker(app)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate Checker Matrxi
%
% 20230905
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sobj = app.sobj;
% 
% Define stim area (sobj.Distance:60 deg -> variable)
disp(sobj.Distance)
Area_deg = [0, 0, sobj.Distance, sobj.Distance];
Area_pix = Deg2Pix(Area_deg, sobj.MonitorDist, sobj.Pixelpitch);
Pos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
C = Pos_list(sobj.FixPos, :);

% Get corner position in pix (left, top, right, bottom)
Area = CenterRectOnPointd(Area_pix, C(1), C(2));


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