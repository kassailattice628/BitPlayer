function [vbl_1, onset, flipend] = Stim_spot1(sobj)
%
% Screen for Delay
% + Photo sensor
%

%Blank while delay period
%Prepare
Screen('FillRect', sobj.wPtr, sobj.bgcol);
%Flip (for dealy)
[vbl_1, onset, flipend] = Screen('Flip', sobj.wPtr);

%Indicator for photo sensor at left bottom of the Monitor
%Prepare
Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);

end