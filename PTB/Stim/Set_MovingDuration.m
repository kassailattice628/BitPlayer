function [distance, duration] = Set_MovingDuration(sobj)


switch sobj.Pattern
    case 'Moving Bar'
        %Change sobj.MoveSpd (deg/sec) -> pix/sec
        MoveSpd_pix = Deg2Pix(sobj.MoveSpd, sobj.MonitorDist, sobj.Pixelpitch);
        
        % Need to fix size...
        distance = sobj.RECT(4) + sobj.StimSize_pix(1); %pix
        duration = distance / MoveSpd_pix; %sec
    
    case {'Moving Spot'}
        MoveSpd_pix = Deg2Pix(sobj.MoveSpd, sobj.MonitorDist, sobj.Pixelpitch);
        distance = Deg2Pix(sobj.Distance, sobj.MonitorDist, sobj.Pixelpitch); %pix
        duration = distance/MoveSpd_pix; %sec
        
    case 'Looming'
        %sobj.LoomingSpd = app.LoomingSpd.Value; %deg/sec
        %sobj.LoomingMaxSize = app.LoomingMax.Value; %diametor deg ->
        
        MoveSpd_pix = Deg2Pix(sobj.LoomingSpd, sobj.MonitorDist, sobj.Pixelpitch);
        %diametor -> radius
        distance = Deg2Pix(sobj.LoomingMaxSize/2, sobj.MonitorDist, sobj.Pixelpitch);
        duration = distance/MoveSpd_pix; %sec
        
    case {'Sine', 'Rect', 'Gabor'}

end
