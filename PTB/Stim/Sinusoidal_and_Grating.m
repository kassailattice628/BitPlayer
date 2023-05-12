function sobj = Sinusoidal_and_Grating(Direction, sobj, INFO)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate shifting sinusoidal or rectangular grating stimuls
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Define moving direction
sobj = Set_Direction(Direction, sobj);
angle = 180 - sobj.MoveDirection;


%Set base stim
base_stimRect = [0, 0, sobj.StimSize_pix(1), sobj.StimSize_pix(2)];
stimRect = CenterRectOnPointd(base_stimRect,...
    sobj.StimCenterPos(1), sobj.StimCenterPos(2));

cycles_per_pix = CPD2CPP(sobj.SpatialFreq, sobj.MonitorDist, sobj.Pixelpitch);

%Generate grating texture;
[gratingtex, sobj] = Make_GratingTexture(sobj);

%Prep Delay %%%%%%%%%%%%%%%%%
[sobj.vbl_1, sobj.onset, sobj.flipend] = Prep_delay(sobj);

%1st frame, phase=0
Screen('DrawTexture', sobj.wPtr, gratingtex, [], stimRect, angle,...
    [], [], [], [], [], [0, cycles_per_pix, sobj.GratingContrast, 0]);

[sobj.vbl_2, ~, ~, ~, sobj.BeamposON] = ...
    Screen('Flip', sobj.wPtr, sobj.vbl_1 + sobj.Delay_sec);
vbl = sobj.vbl_2;
ShowStimInfo(sobj, INFO);
%ShowStimInfo(sobj, app.StiminfoTextArea);
drawnow;

%Grating stimuli
for count = 2:sobj.FlipNum
    phase = count * 360/sobj.FrameRate * sobj.TemporalFreq;
    Screen('DrawTexture', sobj.wPtr, gratingtex, [], stimRect, angle,...
        [], [], [], [], [], [phase, cycles_per_pix, sobj.GratingContrast, 0]);

    %Add Photo Sensor (Left, Bottom)
    Screen('FillRect', sobj.wPtr, 255, [0 sobj.RECT(4)-30, 30, sobj.RECT(4)]);
    vbl = Screen('Flip', sobj.wPtr, vbl + (sobj.MonitorInterval/2));
end

%Stim OFF
sobj = MovingStim_off(sobj, INFO, vbl);

end
