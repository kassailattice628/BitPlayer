function Load_test_images(app)
%
% Load 16*16 or 32*32 images
%

s = app.sobj;

s.Images = uint8(zeros(app.Divide.Value, app.Divide.Value, 10));

if app.Divide.Value == 32
    load('./Images/Decode_SC_Test_v1/test_images_20230911.mat', 'test_img');
    s.Images(:,:,1:5) = test_img;
    load('./Images/Decode_SC_Test_v1/test_fonts_20230911.mat', 'test_font32');
    s.Images(:,:,6:10) = test_font32;
    
elseif app.Divide.Value == 16
    load('./Images/Decode_SC_Test_v1/test_images_20230911.mat', 'test_img16');
    s.Images(:,:,1:5) = test_img16;
    load('./Images/Decode_SC_Test_v1/test_fonts_20230911.mat', 'test_font16');
    s.Images(:,:,6:10) = test_font16;
end

s.Images(s.Images > 0) = 1;

%% Returen
app.sobj = s;


end