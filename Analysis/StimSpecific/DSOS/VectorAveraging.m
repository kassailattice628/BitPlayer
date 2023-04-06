function [L, Ang] = VectorAveraging(y, stim, type)
%
if size(y, 1) > 1
    stim = repmat(stim, [size(y, 1), 1]);
end

switch type
    case 'Direction'
        Z = sum(y .* exp(1i * stim), 2, 'omitnan')./sum(y, 2, 'omitnan');
        L = abs(Z);
        Ang = wrapTo2Pi(angle(Z));

    case 'Orientation'
        Z = sum(y .* exp(2 * 1i * stim), 2, 'omitnan')./sum(y, 2, 'omitnan');
        L= abs(Z);
        Ang = wrapToPi(angle(Z)/2 + pi/2);

        % Wrap tp [-pi/2:pi/2]
        Ang(Ang > pi/2) = Ang(Ang > pi/2) - pi;
        Ang(Ang < -pi/2) = Ang(Ang < -pi/2) + pi;

end

end

