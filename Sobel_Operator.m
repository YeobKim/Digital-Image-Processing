%% WEEK11
clc;

img_50 = imread('50.jpg');
b_50 = rgb2gray(img_50);
c_50 = im2double(b_50);
a_50 = padarray(c_50,[1,1], 'replicate');

edge_50 = edgedetect_sobel(a_50);

img_100 = imread('100.jpg');
b_100 = rgb2gray(img_100);
c_100 = im2double(b_100);
a_100 = padarray(c_100,[1,1], 'replicate');

edge_100 = edgedetect_sobel(a_100);

img_500 = imread('500.jpg');
b_500 = rgb2gray(img_500);
c_500 = im2double(b_500);
a_500 = padarray(c_500,[1,1], 'replicate');

edge_500 = edgedetect_sobel(a_500);

% 동전의 지름을 구하는 부분
for i = 2:299
    for j = 2:299
        if edge_50(i,j-1) * edge_50(i,j) * edge_50(i,j+1) ~= 0
            min_j = j;
            break;
        end
    end
    
    % for문에서 위에서는 j좌표가 움직여서 j를 받고 아래는 i가 움직여서 i를 받음
    
    if edge_50(i,j-1) * edge_50(i,j) * edge_50(i,j+1) ~=0
        min_i = i;
        break;
    end
end

for i = 299:-1:2
    for j = 299:-1:2
        if edge_50(i,j-1) * edge_50(i,j) * edge_50(i,j+1) ~= 0
            max_j = j;
            break;
        end
    end
    
    if edge_50(i,j-1) * edge_50(i,j) * edge_50(i,j+1) ~=0
        max_i = i;
        break;
    end
end

% 피타고라스 정리 이용해서 거리구하기.
dist = sqrt((max_i-min_i)^2 + (max_j-min_j)^2) * 25.4/96 * (300/512)^2;

% 25.4/96 -> 96 pixel 당 25.4mm 한 픽셀을 다루고 있기 때문에 96으로 나눠줌. 
% 300/512 -> 512x512 기준이기 때문에 300x300(우리가 원하는) 것으로 바꿔주기 위해 

fprintf('50원 동전의 지름은 %fmm입니다.\n', dist);

% 50원 = 21.6mm / 100원 = 24mm / 500원 = 26.5mm

realround_50 = 21.6;
err = abs((realround_50 - dist) / realround_50 * 100);

fprintf('50원 동전의 지름의 오차는 %f%%입니다.\n', err);

subplot(231)
imshow(img_50);
subplot(232)
imshow(img_100);
subplot(233)
imshow(img_500);
subplot(234)
imshow(edge_50); 
subplot(235)
imshow(edge_100); 
subplot(236)
imshow(edge_500); 
