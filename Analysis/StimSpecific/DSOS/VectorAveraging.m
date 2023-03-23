function [L, Ang] = VectorAveraging(y, stim, type)
%
switch type
    case 'Direction'
        Z = sum(y .* exp(1i * stim), 'omitnan')/sum(y, 'omitnan');
        L = abs(Z);
        Ang = wrapTo2Pi(angle(Z));

    case 'Orientation'

        Z = sum(y .* exp(2 * 1i * stim), 'omitnan')/sum(y, 'omitnan');
        L= abs(Z);
        
        Ang = wrapToPi(angle(Z)/2 + pi/2);

        % Wrap tp [-pi/2:pi/2]
        Ang(Ang > pi/2) = Ang(Ang > pi/2) - pi;
        Ang(Ang < -pi/2) = Ang(Ang < -pi/2) + pi;

end

end

