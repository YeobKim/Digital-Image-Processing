%% WEEK6
clc;

a = fopen('lena(512x512).raw', 'rb');
file = fread(a);
b = zeros(512,512);

for i = 1:512
    for j = 1:512
        b(i,j) = file(512*(i-1)+j, 1);
    end
end
img = double(b);

figure;
imshow(uint8(b));

img_freq = fft2(img);
img_freq = fftshift(img_freq);

figure;
imshow(uint8(abs(img_freq)));

% LPF 설계
LPF1 = zeros(512,512);
filtersize1 = 50;
LPF2 = zeros(512,512);
filtersize2 = 100;
LPF3 = zeros(512,512);
filtersize3 = 200;
LPF4 = zeros(512,512);
filtersize4 = 400;

LPF1 = My_LPF(LPF1, filtersize1);
LPF2 = My_LPF(LPF2, filtersize2);
LPF3 = My_LPF(LPF3, filtersize3);
LPF4 = My_LPF(LPF4, filtersize4);

% filter_img = zeros(512,512);
% for i = 1:512
%     for j = 1:512
%         filter_img1(i,j) = img_freq(i,j) * LPF1(i,j);
%     end
% end
filter_img1 = img_filter(img_freq, LPF1);
filter_img2 = img_filter(img_freq, LPF2);
filter_img3 = img_filter(img_freq, LPF3);
filter_img4 = img_filter(img_freq, LPF4);
% figure;
% imshow(LPF);
figure;
subplot(221); imshow(LPF1); title('LPF M =50');
subplot(222); imshow(LPF2); title('LPF M =100');
subplot(223); imshow(LPF3); title('LPF M =200');
subplot(224); imshow(LPF4); title('LPF M =400');
% figure;
% imshow(abs(filter_img));

recon_img1 = ifftshift(filter_img1);
recon_img1 = ifft2(recon_img1);
recon_img1 = uint8(recon_img1);

recon_img2 = ifftshift(filter_img2);
recon_img2 = ifft2(recon_img2);
recon_img2 = uint8(recon_img2);

recon_img3 = ifftshift(filter_img3);
recon_img3 = ifft2(recon_img3);
recon_img3 = uint8(recon_img3);

recon_img4 = ifftshift(filter_img4);
recon_img4 = ifft2(recon_img4);
recon_img4 = uint8(recon_img4);

figure;
subplot(221); imshow(recon_img1); title('LPF M =50');
subplot(222); imshow(recon_img2); title('LPF M =100');
subplot(223); imshow(recon_img3); title('LPF M =200');
subplot(224); imshow(recon_img4); title('LPF M =400');
