function [im_tex, sRect, tex_pos] = Make_BarTexture(dist, flipnum, sobj)
%Object Transfer Factor (Distance / flip)
tf = round(dist/flipnum);

%% Prepare Bar

%bar_h = sobj.RECT(4);
bar_h = Deg2Pix(65, sobj.MonitorDist, sobj.Pixelpitch); %Fixed to 65deg
bar_w = sobj.StimSize_pix(1);

%Texture objext
im_matrix = ones(bar_h, bar_w) * sobj.stimlumi;

%Make textue
%im_tex = Screen('MakeTexture', sobj.wPtr, im_matrix, ang, 4);
im_tex = Screen('MakeTexture', sobj.wPtr, im_matrix);
% "4", PTB tries to use especially fast method of tecture cereation.

%Stim position in each frame
tex_pos = zeros(flipnum, 4);

sRect = [1, bar_w; 1, bar_h];

ang_deg = deg2rad(sobj.MoveDirection);

PosCenterX = sobj.ScrCenterX - (sobj.RECT(4) + bar_w)/2 * cos(-ang_deg);
PosCenterY = sobj.ScrCenterY - (sobj.RECT(4) + bar_w)/2 * sin(-ang_deg);

for i = 1:flipnum
    xmove = (i-1) * tf * cos(ang_deg);
    ymove = -(i-1) * tf * sin(ang_deg);
    
    tex_pos(i, :) = [PosCenterX - bar_w/2 + xmove,...
        PosCenterY - bar_h/2 + ymove,...
        PosCenterX + bar_w/2 + xmove,...
        PosCenterY + bar_h/2 + ymove];
end

end