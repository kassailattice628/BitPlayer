function [im_tex, sRect, tex_pos] = Make_BarTexture(dist, flipnum, sobj)
%Object Transfer Factor (Distance / flip)
tf = dist/flipnum;

%% Prepare Bar

%bar_h = sobj.RECT(4); -> fixed bar height as 65 deg;
bar_h = sobj.Bar_heigth_pix;
bar_w = sobj.Bar_width_pix;

%Texture objext
im_matrix = uint8(ones(bar_h, bar_w)) * sobj.stimlumi;

%Make textue
im_tex = Screen('MakeTexture', sobj.wPtr, im_matrix);

%Stim position in each frame
tex_pos = zeros(flipnum, 4);

sRect = [1, bar_w; 1, bar_h];

ang_deg = deg2rad(sobj.MoveDirection);

PosCenterX = sobj.ScrCenterX - (bar_h + bar_w)/2 * cos(-ang_deg);
PosCenterY = sobj.ScrCenterY - (bar_h + bar_w)/2 * sin(-ang_deg);

for i = 1:flipnum
    xmove = round((i-1) * tf * cos(ang_deg));
    ymove = round(-(i-1) * tf * sin(ang_deg));

    tex_pos(i, :) =...
        [PosCenterX - bar_w/2 + xmove,...
        PosCenterY - bar_h/2 + ymove,...
        PosCenterX + bar_w/2 + xmove,...
        PosCenterY + bar_h/2 + ymove];
end

end