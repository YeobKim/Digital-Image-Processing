%% WEEK5
clc;

img = imread('lena.bmp');
watermark = imread('Watermark.png');

%watermark = im2double(watermark);
watermark = rgb2gray(watermark);
bin_mark = imbinarize(watermark);

for row = 1:512
    for col = 1:512
         img8(row,col) = bitand(img(row,col),128); % 각 픽셀에 대해 10000000 곱해서 -> MSB해줌
         img7(row,col) = bitand(img(row,col),64);
         img6(row,col) = bitand(img(row,col),32);
         img5(row,col) = bitand(img(row,col),16);
         img4(row,col) = bitand(img(row,col),8);
         img3(row,col) = bitand(img(row,col),4);
         img2(row,col) = bitand(img(row,col),2);
         img1(row,col) = bitand(img(row,col),1); % 00000001 -> LSB
    end
end

figure(1);
subplot(241);imshow(img8 * 255);title('10000000');
subplot(242);imshow(img7 * 255);title('01000000');
subplot(243);imshow(img6 * 255);title('00100000');
subplot(244);imshow(img5 * 255);title('00010000');
subplot(245);imshow(img4 * 255);title('00001000');
subplot(246);imshow(img3 * 255);title('00000100'); 
subplot(247);imshow(img2 * 255);title('00000010');
subplot(248);imshow(img1 * 255);title('00000001');

% msb lsb 워터마크 삽입해보기 궁금하면.

% for row = 1:512
%     for col = 1:512
%          watermark8(row,col) = bitand(watermark(row,col),128); % 각 픽셀에 대해 10000000 곱해서 -> MSB해줌
%          watermark7(row,col) = bitand(watermark(row,col),64);
%          watermark6(row,col) = bitand(watermark(row,col),32);
%          watermark5(row,col) = bitand(watermark(row,col),16);
%          watermark4(row,col) = bitand(watermark(row,col),8);
%          watermark3(row,col) = bitand(watermark(row,col),4);
%          watermark2(row,col) = bitand(watermark(row,col),2);
%          watermark1(row,col) = bitand(watermark(row,col),1); % 00000001 -> LSB
%     end
% end
% 
% figure(2);
% subplot(241);imshow(watermark8 * 255);title('10000000');
% subplot(242);imshow(watermark7 * 255);title('01000000');
% subplot(243);imshow(watermark6 * 255);title('00100000');
% subplot(244);imshow(watermark5 * 255);title('00010000');
% subplot(245);imshow(watermark4 * 255);title('00001000');
% subplot(246);imshow(watermark3 * 255);title('00000100'); 
% subplot(247);imshow(watermark2 * 255);title('00000010');
% subplot(248);imshow(watermark1 * 255);title('00000001');


for row = 1:512
    for col = 1:512
        img1(row,col) = bin_mark(row,col);
    end
end

for row = 1:512
    for col = 1:512
         new_img(row,col) = bitor(img8(row,col),img7(row,col)); 
         new_img(row,col) = bitor(new_img(row,col),img6(row,col));  
         new_img(row,col) = bitor(new_img(row,col),img5(row,col)); 
         new_img(row,col) = bitor(new_img(row,col),img4(row,col)); 
         new_img(row,col) = bitor(new_img(row,col),img3(row,col)); 
         new_img(row,col) = bitor(new_img(row,col),img2(row,col)); 
         new_img(row,col) = bitor(new_img(row,col),img1(row,col)); 
    end
end

figure(3); 
subplot(121); imshow(img); title('Original');
subplot(122); imshow(new_img); title('Origianl+Watermark');

for row = 1:512
    for col = 1:512
         new_img8(row,col) = bitand(new_img(row,col),128); % 각 픽셀에 대해 10000000 곱해서 -> MSB해줌
         new_img7(row,col) = bitand(new_img(row,col),64);
         new_img6(row,col) = bitand(new_img(row,col),32);
         new_img5(row,col) = bitand(new_img(row,col),16);
         new_img4(row,col) = bitand(new_img(row,col),8);
         new_img3(row,col) = bitand(new_img(row,col),4);
         new_img2(row,col) = bitand(new_img(row,col),2);
         new_img1(row,col) = bitand(new_img(row,col),1); % 00000001 -> LSB
    end
end

figure(4);
subplot(241);imshow(new_img8 * 255);title('10000000');
subplot(242);imshow(new_img7 * 255);title('01000000');
subplot(243);imshow(new_img6 * 255);title('00100000');
subplot(244);imshow(new_img5 * 255);title('00010000');
subplot(245);imshow(new_img4 * 255);title('00001000');
subplot(246);imshow(new_img3 * 255);title('00000100'); 
subplot(247);imshow(new_img2 * 255);title('00000010');
subplot(248);imshow(new_img1 * 255);title('00000001');

