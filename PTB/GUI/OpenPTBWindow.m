function OpenPTBWindow(app)

sobj = app.sobj;

[sobj.wPtr, sobj.RECT] = PsychImaging('OpenWindow', 1, sobj.bgcol);

Screen('BlendFunction', sobj.wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

[sobj.ScrCenterX, sobj.ScrCenterY] = RectCenter(sobj.RECT);

sobj.MonitorInterval = Screen('GetFlipInterval', sobj.wPtr);


%% Load GammaTable 260618
gammaTableFile = 'my_monitor_gamma_table.mat';
if exist(gammaTableFile, 'file')
    load(gammaTableFile, 'gammaTable');
    Screen('LoadNormalizedGammaTable', sobj.wPtr, gammaTable);
    disp('---Applying corrected Gamma table 20260618---');
else
    sca;
    error('Gamma Table File (%s) NOT FOUND!!!', gammaTableFile);
end


app.sobj = sobj;

end
