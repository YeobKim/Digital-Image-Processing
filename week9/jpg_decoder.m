function Y = jpg_decoder(encoded, QP)
blk_size = 8; 
[M N]= size(encoded);
H = M/blk_size;
W = N/blk_size;

blk = zeros(blk_size,blk_size);

for i = 1: H
    for j = 1: W
        blk(:,:) = encoded((i-1)*blk_size+1:i*blk_size,(j-1)*blk_size+1:j*blk_size);
        inverse_quantization_blk = blk*QP;
        inverse_dct_blk = idct2(inverse_quantization_blk);
        decoded((i-1)*blk_size+1:i*blk_size,(j-1)*blk_size+1:j*blk_size) = inverse_dct_blk(:,:);
    end
end

Y= uint8(decoded); 
