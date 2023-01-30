function OpenPTBWindow(app)

sobj = app.sobj;

[sobj.wPtr, sobj.RECT] = PsychImaging('OpenWindow', 1, sobj.bgcol);

Screen('BlendFunction', sobj.wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

[sobj.ScrCenterX, sobj.ScrCenterY] = RectCenter(sobj.RECT);

sobj.MonitorInterval = Screen('GetFlipInterval', sobj.wPtr);

app.sobj = sobj;

end
