function spot_pos = Make_MoveSpot(dist, flipnum, sobj)

%Object Transfer Factor (Distance / flip)
tf = dist/flipnum;

%% Prepare position
%Stim position in each frame
spot_pos = zeros(flipnum, 4);
ang_deg = deg2rad(sobj.MoveDirection);

sz = sobj.StimSize_pix(1);
PosCenterX = sobj.StimCenterPos(1) - sz/2 * cos(-ang_deg);
PosCenterY = sobj.StimCenterPos(2) - sz/2 * sin(-ang_deg);

%Stim cneter in each frame
for i = 1:flipnum
    xmove = (i-1) * tf * cos(ang_deg);
    ymove = (i-1) * tf * sin(ang_deg);
    spot_pos(i,:) = CenterRectOnPointd([0,0,sobj.StimSize_pix],...
        round(PosCenterX +xmove), round(PosCenterY + ymove));
end

end