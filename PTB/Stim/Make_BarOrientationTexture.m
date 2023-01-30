function [im_tex] = Make_BarOrientationTexture(sobj)

%% Prepare Bar
bar_h = sobj.RECT(4);
bar_w = sobj.StimSize_pix(1);

%Texture objext
im_matrix = ones(bar_h, bar_w) * sobj.stimlumi;
im_tex = Screen('MakeTexture', sobj.wPtr, im_matrix, sobj.BarOrientation);

end