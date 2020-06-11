function[] = Decoder(receivedData)

% Decoder performs duties like Inverse differential coding, Inverse Zig-Zag coding for AC coefficients, Inverse 
% Quantization, IDCT, Motion compensation and Usampling.

%% Data Extraction from Database.

decoderBufferZigZagLumaAC = receivedData{1,1};
decoderBufferDifferentialLumaDC = receivedData{1,2};
decoderBufferZigZagCbAC = receivedData{1,3};
decoderBufferDifferentialCbDC = receivedData{1,4};
decoderBufferZigZagCrAC = receivedData{1,5};
decoderBufferDifferentialCrDC = receivedData{1,6};
decoderBufferMVCurrX = receivedData{1,7};
decoderBufferMVCurrY = receivedData{1,8};
decoderBufferIndicationMatrix = receivedData{1,9};

row = 144;
column = 176;

% Calculates padder size.
rowPadded = row/2 + rem(row/2,8);
columnPadded = column/2 + rem(column/2,8);

% Number of frames arrived.
count = size(decoderBufferZigZagLumaAC, 2);
% display(['Count value is = ' num2str(count)]);

% Initializes subsampled matrix for Luma and chroma components.
rcvdSubSampledReferenceFrameLuma = zeros(row, column, 'double');
rcvdSubSampledReferenceFrameCb = zeros(row/2, column/2, 'double');
rcvdSubSampledReferenceFrameCr = zeros(row/2, column/2, 'double');

%%

for number = 1:count;
    %% Matrix Extraction for current frame.

    rcvdZigZagCurrentLumaAC = decoderBufferZigZagLumaAC{1,number};
    rcvdDifferentialCurrentLumaDC = decoderBufferDifferentialLumaDC{1,number};
    rcvdZigZagCurrentCbAC = decoderBufferZigZagCbAC{1,number};
    rcvdDifferentialCurrentCbDC = decoderBufferDifferentialCbDC{1,number};
    rcvdZigZagCurrentCrAC = decoderBufferZigZagCrAC{1,number};
    rcvdDifferentialCurrentCrDC = decoderBufferDifferentialCrDC{1,number};
    rcvdMVMatrixXValue = decoderBufferMVCurrX{1,number};
    rcvdMVMatrixYValue = decoderBufferMVCurrY{1,number};
    rcvdIndicationMatrix = decoderBufferIndicationMatrix{1,number};
       
    %% Inverse Differential Coding.
    
    decoderCurrentLumaDC = inverseDifferentialCoding(rcvdDifferentialCurrentLumaDC);
    decoderCurrentCbDC = inverseDifferentialCoding(rcvdDifferentialCurrentCbDC);
    decoderCurrentCrDC = inverseDifferentialCoding(rcvdDifferentialCurrentCrDC);
    
    %% Inverse Zig-Zag.
        
    inverseZigZagCurrentLuma = inverseZigZag(row, column, decoderCurrentLumaDC, rcvdZigZagCurrentLumaAC, rcvdIndicationMatrix, 2);
    inverseZigZagCurrentCb = inverseZigZag(rowPadded, columnPadded, decoderCurrentCbDC, rcvdZigZagCurrentCbAC, rcvdIndicationMatrix, 1);
    inverseZigZagCurrentCr = inverseZigZag(rowPadded, columnPadded, decoderCurrentCrDC, rcvdZigZagCurrentCrAC, rcvdIndicationMatrix, 1);
    
    %% De-quantization, IDCT & Motion Compensation.
    
    [decoderCurrentLuma, decoderCurrentCb, decoderCurrentCr] = inbuildDecoder(inverseZigZagCurrentLuma, inverseZigZagCurrentCb, inverseZigZagCurrentCr, rcvdMVMatrixXValue, rcvdMVMatrixYValue, rcvdSubSampledReferenceFrameLuma, rcvdSubSampledReferenceFrameCb, rcvdSubSampledReferenceFrameCr, rcvdIndicationMatrix);

    % Stores reconstructed subsampled Luma and Chroma components to decode next frame.
    rcvdSubSampledReferenceFrameLuma = double(decoderCurrentLuma);
    rcvdSubSampledReferenceFrameCb = double(decoderCurrentCb);
    rcvdSubSampledReferenceFrameCr = double(decoderCurrentCr);    
    
    %% Row Column Replication.

    % Luma does not need upsampling.
    decoderUpsampledCurrentLuma = decoderCurrentLuma;
    
    % Upsamples Cb and Cr components using Row Column Replication.
    decoderUpsampledCurrentCb = zeros (row, column, 'uint8');  %Creates zeros matrix for Cb component.
    decoderUpsampledCurrentCr = zeros (row, column, 'uint8');  %Creates zeros matrix for Cr component.
    
    decoderUpsampledCurrentCb(1:2:end,1:2:end)=decoderCurrentCb(1:end,1:end);
    decoderUpsampledCurrentCb(2:2:end,:)=decoderUpsampledCurrentCb(1:2:end,:);
    decoderUpsampledCurrentCb(:,2:2:end)=decoderUpsampledCurrentCb(:,1:2:end);
    
    decoderUpsampledCurrentCr(1:2:end,1:2:end)= decoderCurrentCr(1:end,1:end);
    decoderUpsampledCurrentCr(2:2:end,:)=decoderUpsampledCurrentCr(1:2:end,:);
    decoderUpsampledCurrentCr(:,2:2:end)=decoderUpsampledCurrentCr(:,1:2:end);

    % Concatenates for YCbCr Image.
    decoderCurrentYCbCr = cat(3, decoderUpsampledCurrentLuma, decoderUpsampledCurrentCb, decoderUpsampledCurrentCr);

    % Converts YCbCr to RGB format.
    decoderCurrentRGB = ycbcr2rgb(decoderCurrentYCbCr);

    % Displays Reconstructed Current Frame at Decoder.
    figure();
    imshow(decoderCurrentRGB);
    title(['Reconstructed Current RGB frame ' int2str(number+5) ' at DECODER']);    
    
end
