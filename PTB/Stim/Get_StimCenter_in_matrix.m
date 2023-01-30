function center_xy_list = Get_StimCenter_in_matrix(RECT, DivNum)
%
% Make Center positions in matrix (DivNum * DivNum)
% RECT is area in pixel
% DivNum is grid size for dividing RECT area.
%

RECT_x = RECT(3) - RECT(1);
RECT_y = RECT(4) - RECT(2);

step_x = RECT_x / DivNum;
step_y = RECT_y / DivNum;

center_div = floor([RECT(1) + step_x/2 : step_x : RECT(3) - step_x/2;...
    RECT(2) + step_y/2 : step_y : RECT(4) - step_y/2]);

center_xy_list = zeros(DivNum^2, 2);

for n = 1:DivNum
    center_xy_list(DivNum * (n-1)+1 : DivNum * n, 1) = center_div(1,n);
    center_xy_list((1 : DivNum : DivNum^2)+(n-1), 2) = center_div(2,n);
end