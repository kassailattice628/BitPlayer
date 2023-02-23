function [sac_mat1v, sac_mat2v, sac_mat1h, sac_mat2h] =...
    Get_peri_saccade_single(D, P, sf, range_sec)
%
% D = SaveData(:,1:2, n); n is trial number
% P = ParamsSave{1,n}
% P.p_saccades
%
% Outout
% sac_mat1v: vertical

%% peri saccade
%vertical 
sac_mat1v = [];
sac_mat2v = [];

%horizontal
sac_mat1h = [];
sac_mat2h = [];

% +/- range_sec
range_point = range_sec * sf;
t = 0:1/sf: (size(D,1))/sf;

%%
for num_saccades = 1:length(P.p_saccades)
    
    % Check range
    i1 = P.p_saccades(num_saccades) - range_point;
    i2 = i1 + range_point * 2;

    if i1 <= 0 || i2 > size(D, 1)
        % out of range
        continue;
    else
        % a saccades was found
        if (D(i2,1) - D(i1,1)) > 0
            % nasal direction
            d = D(i1:i2, 1);
        else
            % temporal direction
            d = -D(i1:i2, 1);
        end
        
        %align by 30% rise (fall) timing
        [t_30, ~] = midcross(d, t(i1:i2), 'MidPercentReferenceLevel', 30);
        
        % recalculate range_point
        i1 = uint16(t_30(1) * sf - range_point);
        i2 = i1 + range_point * 2;
        
        if i1 <= 0 || i2 > size(D, 1)
            %out of range
            continue;
        else
            if(D(i2,1) - D(i1,1)) > 0
                %nasal direction
                sac_mat1v = [sac_mat1v; D(i1:i2, 2)'];
                sac_mat1h = [sac_mat1h; D(i1:i2, 1)'];
            else
                %temporal direction
                sac_mat2v = [sac_mat2v; D(i1:i2, 2)'];
                sac_mat2h = [sac_mat2h; D(i1:i2, 1)'];
            end
        end
    end
end

end
