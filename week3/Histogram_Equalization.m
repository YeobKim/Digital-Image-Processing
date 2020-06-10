%% WEEK3
clc;

img = imread('lena.tiff');
img = rgb2gray(img);
img_dark = img/4;
figure(1);
imshow(img);
histo = zeros(1,256);

for i=1:512
    for j=1:512
        k = img_dark(i,j); % 하나하나 픽셀에 대해 조사를 하겠다.
        histo(k) = histo(k) + 1; % 1씩 추가해서 빈도수를 세겠다. 
    end
end

pdf = histo ./ (512*512);

% figure(1);
% stem(histo); title('histogram');
% figure(2);
% stem(pdf); title('PDF')

cdf = cumsum(histo) / (sum(histo));
% figure(3);
% stem(cdf); title('CDF');

imgeq = img_dark;

for i=1:512
    for j=1:512
        imgeq(i,j) = round(256*cdf(imgeq(i,j)));
        % round -> 가장 가까운 소수 자릿수 또는 정수로 반올림, 정수로 만들어줌
    end
end

figure(2);
subplot(121);
imshow(img_dark);
subplot(122);
imshow(imgeq);
