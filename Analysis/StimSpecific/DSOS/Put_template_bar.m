function Put_template_bar(i, C, Col, ang)
%%

W = 4;
L = 30;

X = [C(1,i) - L/2 * cos(ang), C(1,i) + L/2 * cos(ang)];
Y = [C(2,i) + L/2 * sin(ang), C(2,i) - L/2 * sin(ang)];
line(X, Y, 'Color', Col, 'LineWidth', W)
hold on


end
