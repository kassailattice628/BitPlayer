function Check_StimeArea_Distance(app)
%
% When DecodeSC(s) are selected,
% Check and Set stim size;

sobj = app.sobj;

% update stim area.
sobj.Distance = app.Distance.Value;
% update stim number of grid 
sobj.Div_grid = app.Divide.Value;


%%
% Define stim area (sobj.Distance:60 deg -> variable)
Area_deg = [0, 0, sobj.Distance, sobj.Distance];
Area_pix = Deg2Pix(Area_deg, sobj.MonitorDist, sobj.Pixelpitch);

if Area_pix > sobj.scr.height
    % If stim area is larget than monitor height, adjust stim area to
    % monitor height.
    Area_pix = sobj.scr.height;
    sobj.Distance = Pix2Deg(Area_pix, sobj.MonitorDist, sobj.Pixpitch);
    app.Distance.Value = sobj.Distance;
    errordlg('Stim height is larget than the Display height.')
end

% Get stim center (FixPos in DivNum^2 matrix)
Pos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);
C = Pos_list(sobj.FixPos, :);

% Get corner position in pix (left, top, right, bottom)
Area = CenterRectOnPointd(Area_pix, C(1), C(2));

%Check stim area (Photo sensor area is 50 pix^2 on left bottom corner)
if Area(1) < 1 || Area(2) < 1 ||...
        Area(3) > sobj.scr.width || Area(4) > sobj.scr.height

    % Reset monito division
    app.MonitorDiv.Value = 9;
    sobj.DivNum = 9;
    app.MonitorDiv_Label.Text = [num2str(app.MonitorDiv.Value),...
        'x', num2str(app.MonitorDiv.Value), ' Matrix'];

    app.FixedPos_Label.Text = ['in ', num2str(app.MonitorDiv.Value),...
        'x', num2str(app.MonitorDiv.Value), ' Matrix'];

    app.FixedPos.Value = 41;
    sobj.FixPos = 41;

    errordlg('Checker Area is out of Stim Monitor.')

elseif Area(1) < 50 && Area(4) > sobj.scr.height - 50
    %Left bottom is overlapped with stim monitor.

    app.MonitorDiv.Value = 9;
    sobj.DivNum = 9;
    app.MonitorDiv_Label.Text = [num2str(app.MonitorDiv.Value),...
        'x', num2str(app.MonitorDiv.Value), ' Matrix'];
    
    app.FixedPos_Label.Text = ['in ', num2str(app.MonitorDiv.Value),...
        'x', num2str(app.MonitorDiv.Value), ' Matrix'];

    app.FixedPos.Value = 41;
    sobj.FixPos = 41;

    errordlg('Checker Area is overlapped on the photo sensor area.')
end

%%

app.sobj = sobj;
Set_RandChecker(app);
Load_test_images(app);

end

