function [vbl_2, BeamposON, vbl_3, BeamposOFF] = Stim_spot2(sobj, gui_info)
%
% Stim ON
% + OFF
%
% serport = app.SerPort

%Flip (Stim ON)
[vbl_2, ~, ~, ~, BeamposON] = ...
    Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
ShowStimInfo(sobj, gui_info)

%Prepare blank full screen
Screen('FillRect', sobj.wPtr, sobj.bgcol);

%Flip (Stim OFF)
[vbl_3, ~, ~, ~, BeamposOFF] = ...
    Screen('Flip', sobj.wPtr, vbl_2 + sobj.Duration_sec);
ResetStimInfo(gui_info);


end
