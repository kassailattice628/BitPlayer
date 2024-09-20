function Load_test_images(app)
%
% Load 16*16 or 32*32 images
%
% Code for generating images
% GoogleDrive/5_Research/Decode_SC/PIL_test/
%

s = app.sobj;

s.Images = uint8(zeros(app.Divide.Value, app.Divide.Value, 10));

grid_size = app.CheckerDivDropDown.Value;
f1 = append('test_img', grid_size);
load('./Images/Decode_SC_Test_v1/test_images_20240920.mat', f1);
assignin('caller', f1);
s.Images(:,:,1:5) = f1;

if app.CheckerDivDropDown.Value == 32
    load('./Images/Decode_SC_Test_v1/test_images_20230911.mat', 'test_img32');
    s.Images(:,:,1:5) = test_img32;
    load('./Images/Decode_SC_Test_v1/test_fonts_20230912.mat', 'test_font32');
    s.Images(:,:,6:10) = test_font32;
    
elseif app.Divide.Value == 16
    load('./Images/Decode_SC_Test_v1/test_images_20230911.mat', 'test_img16');
    s.Images(:,:,1:5) = test_img16;
    load('./Images/Decode_SC_Test_v1/test_fonts_20230912.mat', 'test_font16');
    s.Images(:,:,6:10) = test_font16;
end

s.Images(s.Images > 0) = 1;

%% Returen
app.sobj = s;


end