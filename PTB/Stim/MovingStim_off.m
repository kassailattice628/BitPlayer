function sobj = MovingStim_off(sobj, stiminfo)
% stiminfo: app.StiminfoTextArea
% serport: app.SerPort
%


%Stim OFF
Screen('FillRect', sobj.wPtr, sobj.bgcol);
[sobj.vbl_3, ~, ~, ~, sobj.BeamposOFF] = Screen('Flip', sobj.wPtr, vbl);

ResetStimInfo(stiminfo);
drawnow;


end