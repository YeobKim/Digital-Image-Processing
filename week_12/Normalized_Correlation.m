clc;

lena = imread('lena.jpg');
patch  = imread('lena_patch.png');

figure();
imshowpair(lena,patch, 'montage');

c = normxcorr2(patch,lena);

figure(), surf(c), shading flat;

% find라는 함수를 이용해서 max값을 찾아준다.
[ypeak, xpeak] = find(c==max(c(:)));

yoffset = ypeak - size(patch, 1);
xoffset = xpeak - size(patch, 2);

% box를 입력해주는 부분
for i = yoffset-1:yoffset + size(patch,1)+1 
    lena(i, xoffset-1) = 255; 
    lena(i, xoffset+size(patch, 2)+1) = 255;
end

for j = xoffset-1:xoffset + size(patch,2)+1
    lena(yoffset-1,j) = 255; 
    lena(yoffset+size(patch, 1)+1,j) = 255;
end

figure();
imshow(lena);
