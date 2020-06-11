function [reconstructedLuma, reconstructedCb, reconstructedCr] = inbuildDecoder(lumaComp, CbComp, CrComp, MVX, MVY, refLuma, refCb, refCr, indicatorMatrix)

%% Inverse Quantization.
quantizationValue = 128;
invQuantLuma = lumaComp * quantizationValue;
invQuantCb = CbComp * quantizationValue;
invQuantCr = CrComp * quantizationValue;

%% Inverse DCT.

[originalRow, originalColumn] = size(lumaComp);

invDCTLuma = inverseDCT(originalRow, originalColumn, invQuantLuma);
invDCTCb = inverseDCT(originalRow/2, originalColumn/2, invQuantCb);
invDCTCr = inverseDCT(originalRow/2, originalColumn/2, invQuantCr);

%% Reconstructs Luma Component.
for i=0:(originalRow/16)-1;
    for j=0:(originalColumn/16)-1;
        if(indicatorMatrix(i+1,j+1) ~= 1)
            addXLuma = MVX(i+1,j+1);
            addYLuma = MVY(i+1,j+1);
            variable1 = invDCTLuma((i*16)+1:(i+1)*16, (j*16)+1:(j+1)*16);
            variable2 = double(refLuma(((i*16)+1-addXLuma):(((i+1)*16)-addXLuma), ((j*16)+1-addYLuma):(((j+1)*16)-addYLuma)));
            reconstructedLuma((i*16)+1:(i+1)*16, (j*16)+1:(j+1)*16) = uint8(variable1 + variable2);
          
        else
            reconstructedLuma((i*16)+1:(i+1)*16, (j*16)+1:(j+1)*16) = double(refLuma(((i*16)+1):((i+1)*16), ((j*16)+1:((j+1)*16))));
        end
    end
end
    
%% Reconstructs Chroma Component.
for i=0:(originalRow/16)-1;
    for j=0:(originalColumn/16)-1;
         if(indicatorMatrix(i+1,j+1) ~= 1)
            addXChroma = floor(MVX(i+1,j+1)/2);
            addYChroma = floor(MVY(i+1,j+1)/2);
            reconstructedCb((i*8)+1:(i+1)*8, (j*8)+1:(j+1)*8) = uint8(invDCTCb((i*8)+1:(i+1)*8, (j*8)+1:(j+1)*8) + double(refCb(((i*8)+1-addXChroma):(((i+1)*8)-addXChroma), ((j*8)+1-addYChroma):(((j+1)*8)-addYChroma))));
            reconstructedCr((i*8)+1:(i+1)*8, (j*8)+1:(j+1)*8) = uint8(invDCTCr((i*8)+1:(i+1)*8, (j*8)+1:(j+1)*8) + double(refCr(((i*8)+1-addXChroma):(((i+1)*8)-addXChroma), ((j*8)+1-addYChroma):(((j+1)*8)-addYChroma))));
         else
            reconstructedCb((i*8)+1:(i+1)*8, (j*8)+1:(j+1)*8) = uint8(refCb(((i*8)+1):((i+1)*8), ((j*8)+1):((j+1)*8)));
            reconstructedCr((i*8)+1:(i+1)*8, (j*8)+1:(j+1)*8) = uint8(refCr(((i*8)+1):((i+1)*8), ((j*8)+1):((j+1)*8)));
        end
    end
end
