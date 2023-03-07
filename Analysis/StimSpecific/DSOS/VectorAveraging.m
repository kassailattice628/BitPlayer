function [L, Ang] = VectorAveraging(y, stim, type)
%
switch type
    case 'Direction'
        Z = sum(y .* exp(1i * stim))/sum(y);
        L = abs(Z);
        Ang = wrapTo2Pi(angle(Z));

    case 'Orientation'

        Z = sum(y .* exp(2* 1i * stim))/sum(y);
        L= abs(Z);

        a = angle(Z)/2 + pi/2;
        Ang = a;

        % Wrap tp [-pi:pi]
        cond = a > pi/2 || 3*pi/2 > a;
        Ang(cond) = Ang(cond) - pi;
end

end

