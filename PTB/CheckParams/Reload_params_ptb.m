function Reload_params_ptb(app)
% When parameters are changed in GUI
% Reload and update setting change colors in GUI

% Load current sobj
sobj = app.sobj;

%%
sobj.duration_sec = app.Duration.Value;
app.Duration_Label.Text = ['ms = ', num2str(round(sobj.duration_sec / app.sobj.MonitorInterval)), ' flips'];

sobj.delay_sec = app.Delay.Value;
app.Delay_Label.Text = ['ms = ', num2str(round(sobj.delay_sec / app.sobj.MonitorInterval)), ' flips'];

sobj.divnum = app.MonitorDiv.Value;
app.MonitorDiv_Label.Text = ['in ', num2str(sobj.divnum), 'x', num2str(sobj.divnum), ' mat'];

sobj.fixepos = app.FixedPos.Value;
app.FixedPos_Label.Text = ['in ', num2str(sobj.divnum), 'x', num2str(sobj.divnum), ' mat'];

sobj.looming_Size = app.LoomingMax.Value;
sobj.imageNum = app.NumImages.Value;
sobj.list_img = 1:sobj.imageNum;

%Mosaic
sobj.dots_density = app.MosaicDensity.Value;

sobj.div_zoom = app.Divide.Value; %deg step
sobj.dist = app.Distance.Value; %deg

%% Stim Position
% sobj.CenterPos_list = Get_StimCenter_in_matrix(sobj.RECT, sobj.DivNum);








%% update 
app.sobj = sobj;

end
