%% WEEK9
clc;

img = imread('lena.jpg');

subplot(2,3,1);
imshow(img); title('Origin img');
QP = [1,16,32,64,128];

for i  = 1:length(QP)
    jpg = jpg_encoder(img, QP(i));
    result = jpg_decoder(jpg, QP(i));
    
    subplot(2,3,i+1);
    imshow(result); title('QP ' + string(QP(i)) + ' img')
    % imsave;
    peaksnr = psnr(result, img);
    disp("QP : " + string(QP(i)) + " PSNR is " + string(peaksnr));
end

