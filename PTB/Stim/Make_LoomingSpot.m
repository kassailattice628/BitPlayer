function spot_i = Make_LoomingSpot(flipnum, sobj)

%Stim size in each frame
sz = linspace(0, sobj.MovingDistance, flipnum);
spot_i = zeros(flipnum, 4);

for i = 1:flipnum
    spot_i(i,:) = CenterRectOnPointd([0, 0, sz(i), sz(i)],...
        sobj.StimCenterPos(1), sobj.StimCenterPos(2));  
end

end