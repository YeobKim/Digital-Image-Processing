clc;

img = imread('lena.bmp');
noisy_img1 = imnoise(img, 'gaussian', 0, 0.01);
% 뒤에 숫자 0.01일 때 보다 0.1일때가 노이즈가 엄청 더 심하다. 숫자가 클수록 노이즈 심해짐.
noisy_img2 = imnoise(img, 'salt & pepper', 0.02);

pad_noisy_img1 = padarray(noisy_img1, [1,1], 'both');
pad_noisy_img2 = padarray(noisy_img2, [1,1], 'both');
% both는 padding값이 0의 값을 가지고 replicate는 주변값을 이용한다.

pad_noisy_img1 = im2double(pad_noisy_img1);
pad_noisy_img2 = im2double(pad_noisy_img2);

% imshow(pad_noisy_img1);
LPF = 1/16 * [[1 2 1];[2 4 2];[1 2 1]];

clean_LPF1 = conv2(pad_noisy_img1, LPF);
clean_LPF2 = conv2(pad_noisy_img2, LPF);

MF = zeros(3,3);
MF1 = median(MF,'all');

% for i = 1:514
%     for j = 1:514
%         clean_img1(i,j) =  conv(pad_noisy_img1(i,j), LPF(i,j));
%     end
% end

clean_med1 = medfilt2(pad_noisy_img1, [3,3]);
clean_med2 = medfilt2(pad_noisy_img2, [3,3]);

% clean_med1 = conv2(pad_noisy_img1, medfilt2(pad_noisy_img1));
% clean_med2 = conv2(pad_noisy_img2, medfilt2(pad_noisy_img2));

figure(1);
subplot(221);
imshow(noisy_img1); title('noisy');
subplot(223);
imshow(noisy_img2); title('noisy');
subplot(222);
imshow(clean_LPF1); title('clean LPF');
subplot(224);
imshow(clean_LPF2); title('clean LPF');

figure(2);
subplot(221);
imshow(noisy_img1); title('noisy');
subplot(223);
imshow(noisy_img2); title('noisy');
subplot(222);
imshow(clean_med1); title('clean Median');
subplot(224);
imshow(clean_med2); title('clean Median');

