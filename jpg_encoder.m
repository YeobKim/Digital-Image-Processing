function Y = jpg_encoder(origin,QP)
blk_size = 8; 
origin = double(origin);
[M N]= size(origin);
H = M/blk_size;
W = N/blk_size;

blk = zeros(blk_size,blk_size);
encoded = zeros(M,N);

for i = 1: H
    for j = 1: W
        blk(:,:) = origin((i-1)*blk_size+1:i*blk_size,(j-1)*blk_size+1:j*blk_size);
        dct_blk = dct2(blk);
        quantization_blk = round((dct_blk)/QP);
        encoded((i-1)*blk_size+1:i*blk_size,(j-1)*blk_size+1:j*blk_size) = quantization_blk(:,:);
    end
end

Y= encoded;