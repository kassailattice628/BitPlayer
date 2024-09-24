function Load_test_images(app)
%
% Load 16*16 or 32*32 images
% Adding 5*5 and 8*8 dot map 20240924
% 
% Code for generating images
% GoogleDrive/5_Research/Decode_SC/PIL_test/
%

s = app.sobj;

str_grid = app.CheckerDivDropDown.Value;
s.Images = uint8(zeros(str2double(str_grid), str2double(str_grid), 10));

D = load('./Images/Decode_SC_Test_v1/test_images_20240924.mat');
s.Images(:,:,1:5) = D.(['test_img' str_grid]);
D = load('./Images/Decode_SC_Test_v1/test_fonts_20240924.mat');
s.Images(:,:,6:10) = D.(['test_font' str_grid]);

% 
% if app.CheckerDivDropDown.Value == 32
%     load('./Images/Decode_SC_Test_v1/test_images_20230911.mat', 'test_img32');
%     s.Images(:,:,1:5) = test_img32;
%     load('./Images/Decode_SC_Test_v1/test_fonts_20230912.mat', 'test_font32');
%     s.Images(:,:,6:10) = test_font32;
%     
% elseif app.Divide.Value == 16
%     load('./Images/Decode_SC_Test_v1/test_images_20230911.mat', 'test_img16');
%     s.Images(:,:,1:5) = test_img16;
%     load('./Images/Decode_SC_Test_v1/test_fonts_20230912.mat', 'test_font16');
%     s.Images(:,:,6:10) = test_font16;
% end

s.Images(s.Images > 0) = 1;

%% Returen
app.sobj = s;


end