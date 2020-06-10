%%
clc;

img = imread('lena.tiff');
img1 = img;
img2 = img;
img3 = img;

% :,: 가로세로 2:3 채널(2ch~3ch을 0으로 선언) => 채널을 분리해주는 방법
img1(:,:,2:3) = 0;
R = img1;
img2(:,:,1:2) = 0;
B = img2;
% 2ch만 살려야하기 때문에 1, 3ch을 빼주는 것.
img3(:,:,1) = 0;
img3(:,:,3) = 0;
G = img3;

figure(1);
subplot(221); 
imshow(img);
subplot(222); 
imshow(R); 
subplot(223); 
imshow(G); 
subplot(224); 
imshow(B);

% CMY변환
C = 255.0-R;
M = 255.0-G;
Y = 255.0-B;

figure(2);
subplot(221); 
imshow(img);
subplot(222); 
imshow(C);
subplot(223);
imshow(M);
subplot(224); 
imshow(Y);

% HSI변환
img=double(img)/255;

R=img(:,:,1);
G=img(:,:,2);
B=img(:,:,3);
% R = double(R)/255;
% G = double(G)/255;
% B = double(B)/255;

I = (1/3)*(R+G+B);

S = 1- (1./(I+0.00001)).*min(img,[],3); 

numi=0.5*((R-G)+(R-B));
denom=((R-G).^2+((R-B).*(G-B))).^0.5;
delta = acosd(numi./(denom+0.000001)); % 분모가 0이 되는 것을 방지하기 위해서 아주 작은 수를 더해준다.

if B<G
    H = delta;
else
    H = 360-delta;
end
H=H/360;

figure(4);
subplot(221);
imshow(img);
subplot(222);
imshow(I);
subplot(223);
imshow(S);
subplot(224);
imshow(H);

