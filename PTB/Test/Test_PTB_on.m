function Test_PTB_on(sobj)

%Prepare Background 
Screen('FillRect', sobj.wPtr, sobj.bgcol); 
[vbl_1, onset, flipend] = Screen('Flip', sobj.wPtr);

%Stim ON
Screen('FillRect', sobj.wPtr, 255, [0, sobj.RECT(4)-30, 30, sobj.RECT(4)]);
[vbl_2, ~, ~, ~, sobj.BeamposON] =...
    Screen('Flip', sobj.wPtr, vbl_1 + sobj.Delay_sec);

%Stim OFF
[vbl_3, ~, ~, ~, sobj.BeamposOFF] =...
    Screen('Flip', sobj.wPtr, vbl_2 + sobj.Duration_sec);


end
