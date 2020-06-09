a = fopen('D:\한양대학교\과제\영상처리\1주차\lena(512x512).raw', 'rb');
file = fread(a);
b = zeros(512,512);

for i = 1:512
    for j = 1:512
        b(i,j) = file(512*(i-1)+j, 1);
    end
end

c = uint8(b); % 0-255의 값으로 변환

imwrite(c, 'D:\한양대학교\과제\영상처리\1주차\lena(512x512).jpg');
imwrite(c, 'D:\한양대학교\과제\영상처리\1주차\lena(512x512).png');
imwrite(c, 'D:\한양대학교\과제\영상처리\1주차\lena(512x512).bmp');

fclose(a);

