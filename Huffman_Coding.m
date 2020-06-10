%% WEEK7
clc;

img = imread('lena.bmp');
% 영상을 3비트로 변환
img3 = grayslice(img,8); % 8->3bits if 256 -> 8bits 2->1bits(black or white)

imshow(mat2gray(img3));

% count에 점점 쌓여간다는 개념
count = [];
for i =0:7
    count(i+1) = sum(img3(:) == i);
end
  
symbols = 0:7;

% count 된 것을 512x512 픽셀을 나눠서 (허프만 코딩 함수를 이용하기 위해)
prob = count/(512*512); 

[dict, avglen] = huffmandict(symbols, prob);

for i = 0:7
    disp('Huffman code of ' + string(i) + ' is ' + join(string(dict{i+1,2})));
end


disp("Original Average length is " + string(log2(length(symbols))));
disp("Huffman Average length is " + string(avglen));
disp("Compressed rate is " + string(100*(1-avglen/log2(length(symbols)))) + "%");

