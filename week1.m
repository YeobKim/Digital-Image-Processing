a = fopen('D:\�Ѿ���б�\����\����ó��\1����\lena(512x512).raw', 'rb');
file = fread(a);
b = zeros(512,512);

for i = 1:512
    for j = 1:512
        b(i,j) = file(512*(i-1)+j, 1);
    end
end

c = uint8(b); % 0-255�� ������ ��ȯ

imwrite(c, 'D:\�Ѿ���б�\����\����ó��\1����\lena(512x512).jpg');
imwrite(c, 'D:\�Ѿ���б�\����\����ó��\1����\lena(512x512).png');
imwrite(c, 'D:\�Ѿ���б�\����\����ó��\1����\lena(512x512).bmp');

fclose(a);

