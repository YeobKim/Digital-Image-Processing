function [result] = edgedetect_sobel(coin_image)
% Input : coin_image    
% Output = result

maskX = [-1 0 1 ; -2 0 2 ; -1 0 1];
maskY = [-1 -2 1 ; 0 0 0 ; -1 2 1];

gx = conv2(coin_image, maskX);
gy = conv2(coin_image, maskY);

result = abs(gx) + abs(gy);
