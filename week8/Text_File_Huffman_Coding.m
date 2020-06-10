%% WEEK8
clc;

fid = fopen('오바마 당선 연설 영문.txt','r');
seq = fread(fid, '*char');

% reshape 함수를 이용해서 seq를 일자로 만들어준다. 1x1082로
seq2 = reshape(seq,1,length(seq));

% 단어별로 나누어진다.
newStr = split(string(seq2)); 
% 특수문자 때문에 같은 단어도 다른단어로 인식이 될수 있다. 특수문자 없애주기 위해 정규식사용
newStr = regexprep(newStr,'\\', '');
newStr = ["";newStr];

% 겹치지 않는 단어들을 분류해줌
symbols = unique(newStr);

count = zeros(1, length(symbols));
% 공백문자의 개수가 있기 때문에 -1을 해줌
count(1) = length(newStr) - 1;

for i =2:length(symbols)
    count(i) = sum(newStr(:) == symbols(i));
end

prob = count/sum(count);

[dict,avglen] = huffmandict([1:length(symbols)], prob);

disp("Unique word is " + string(length(symbols)));
disp("Original Average length is " + string(log2(length(symbols))));
disp("Huffman Average length is " + string(avglen));
disp("Compressed rate is " + string(100*(1-avglen/log2(length(symbols)))) + "%");

% 최빈단어 10개를 뽑아내는 부분

disp("Top 10 frequent words");
[B,I] = sort(prob, 'descend');

for i = 1:10
    disp(string(i) + ":" + symbols(dict{I(i),1}) + " / count : " + string(count(I(i))) + " - code : " + join(string(dict{I(i),2}), ""));
end

