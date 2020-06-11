clc;
clear all;
close all;

%%

videoSequence = VideoReader('walk_qcif.avi');

count = 1;
while (hasFrame(videoSequence) && count <11);
    frameNumber(count).cdata = readFrame(videoSequence);         
    count = count+1;
end

originalFrameCopy = frameNumber;  


encoderBufferZigzagLumaAC = cell(1,5);
encoderBufferDifferentialLumaDC = cell(1,5);
encoderBufferZigzagCbAC = cell(1,5);
encoderBufferDifferentialCbDC = cell(1,5);
encoderBufferZigzagCrAC = cell(1,5);
encoderBufferDifferentialCrDC = cell(1,5);
encoderBufferMVCurrX = cell(1,5);
encoderBufferMVCurrY = cell(1,5);
encoderBufferIndicationMatrix = cell(1,5);



for number = 6:(count-1);

    
    figure();
    imshow(frameNumber(number).cdata);
    title(['Original Current Frame ' int2str(number) ' at ENCODER in RGB Format']); 
    

    currentFrameYCbCr = rgb2ycbcr(frameNumber(number).cdata);
    currentFrameY = currentFrameYCbCr(:,:,1);
    currentFrameCb = currentFrameYCbCr(:,:,2);
    currentFrameCr = currentFrameYCbCr(:,:,3); 
    
   
    [row, column] = size(currentFrameY);
    
        
    subSampledYCurrentFrame = currentFrameY;
    subSampledCbCurrentFrame = currentFrameCb(1:2:end, 1:2:end);
    subSampledCrCurrentFrame = currentFrameCr(1:2:end, 1:2:end);
    

    motionVectorXValue = zeros(row/16,column/16,'double');    
    motionVectorYValue = zeros(row/16,column/16,'double');    
    
   
    differenceFrameLuma = zeros(row, column, 'double');
    differenceFrameCb = zeros(row/2, column/2, 'double');
    differenceFrameCr = zeros(row/2, column/2, 'double');
       
  
    indicationMatrix = zeros(row/16,column/16,'double');
 
    
    subSampledYReferenceFrame = zeros(row, column, 'double');
    subSampledCbReferenceFrame = zeros(row/2, column/2, 'double');
    subSampledCrReferenceFrame = zeros(row/2, column/2, 'double');
        
 
    
    if(number ~= 6)

        
        figure();
        imshow(frameNumber(number-1).cdata);
        title(['Reference Frame ' int2str(number-1) ' at ENCODER in RGB Format']);
        
        
        referenceFrameYCbCr = rgb2ycbcr(frameNumber(number-1).cdata);
        referenceFrameY = referenceFrameYCbCr(:,:,1); 
        referenceFrameCb = referenceFrameYCbCr(:,:,2); 
        referenceFrameCr = referenceFrameYCbCr(:,:,3);
        
     
        subSampledYReferenceFrame = referenceFrameY;
        subSampledCbReferenceFrame = referenceFrameCb(1:2:end, 1:2:end);
        subSampledCrReferenceFrame = referenceFrameCr(1:2:end, 1:2:end);
        

        for p = 0:((row/16)-1);
           for q = 0:((column/16)-1);

               currentMacroBlock = double(currentFrameY((p*16)+1:(p+1)*16, (q*16)+1:(q+1)*16));

             

               if((((q*16)+1)-8)<=0)
                   startColumnSearchWindow = 1;
               else
                   startColumnSearchWindow = (((q*16)+1)-8);
               end

               if((((p*16)+1)-8)<=0)
                   startRowSearchWindow = 1;
               else
                   startRowSearchWindow = (((p*16)+1)-8);
               end

               if(((q+1)*16)+8 >= column)
                   endColumnSearchWindow = column;
               else
                   endColumnSearchWindow = ((q+1)*16)+8;
               end

               if(((p+1)*16)+8 >= row)    
                   endRowSearchWindow = row;
               else
                   endRowSearchWindow = ((p+1)*16)+8;
               end

               referenceSW = double(referenceFrameY(startRowSearchWindow : endRowSearchWindow, startColumnSearchWindow : endColumnSearchWindow));

               [ xShift, yShift, differenceFrameLuma((p*16)+1:(p+1)*16, (q*16)+1:(q+1)*16)] = exhaustiveSearchAlgorithm( currentMacroBlock, referenceSW);

               motionVectorXValue(p+1,q+1) = (p*16 + 1) - (xShift - 1 + startRowSearchWindow);
               motionVectorYValue(p+1,q+1) = (q*16 + 1) - (yShift - 1 + startColumnSearchWindow);

           end
        end
        
        figure;
        imshow(uint8(differenceFrameLuma));
        title(['Luma Component of Difference frame for Current Frame No. ' int2str(number+1) ' at ENCODER']);


        [x,y] = meshgrid(1:((column/16)),1:((row/16)));
        figure;
        quiver(x,y, motionVectorXValue, motionVectorYValue);
        title(['Motion Vector for Frame No. ' int2str(number+1)]);

        for p=0:(row/16)-1;
            for q=0:(column/16)-1;
                movementXChroma = floor(motionVectorXValue(p+1,q+1)/2);
                movementYChroma = floor(motionVectorYValue(p+1,q+1)/2);
                differenceFrameCb((p*8)+1:(p+1)*8, (q*8)+1:(q+1)*8) = double(subSampledCbCurrentFrame((p*8)+1:(p+1)*8, (q*8)+1:(q+1)*8)) - double(subSampledCbReferenceFrame(((p*8)+1-movementXChroma):(((p+1)*8)-movementXChroma), ((q*8)+1-movementYChroma):(((q+1)*8)-movementYChroma)));
                differenceFrameCr((p*8)+1:(p+1)*8, (q*8)+1:(q+1)*8) = double(subSampledCrCurrentFrame((p*8)+1:(p+1)*8, (q*8)+1:(q+1)*8)) - double(subSampledCrReferenceFrame(((p*8)+1-movementXChroma):(((p+1)*8)-movementXChroma), ((q*8)+1-movementYChroma):(((q+1)*8)-movementYChroma)));
            end
        end
    end     
        

    
    if(number==6)        
        differenceFrameLuma = double(subSampledYCurrentFrame);
        differenceFrameCb = double(subSampledCbCurrentFrame);
        differenceFrameCr = double(subSampledCrCurrentFrame); 
    end
        
   

    [rowY, colY] = size(differenceFrameLuma);
    [rowCbCr,colCbCr] = size(differenceFrameCb);
    
    padderY = zeros(mod(rowY,8),mod(colY,8));
    padderCbCr = zeros(mod(rowCbCr,8),mod(colCbCr,8));


    YDCTMatrix = [differenceFrameLuma; double(padderY)];
    CbDCTMatrix = [differenceFrameCb; double(padderCbCr)];
    CrDCTMatrix = [differenceFrameCr; double(padderCbCr)];


    [rowPaddedY, colPaddedY] = size(YDCTMatrix);
    [rowPaddedCbCr, colPaddedCbCr] = size(CbDCTMatrix);
    

    for m = 0:((rowPaddedY/8)-1);
       for n = 0:((colPaddedY/8)-1);
          YDCTCurrentFrame((m*8)+1:(m+1)*8, (n*8)+1:(n+1)*8) = dct2(YDCTMatrix((m*8)+1:(m+1)*8, (n*8)+1:(n+1)*8));
       end
    end

    
    for m = 0:((rowPaddedCbCr/8)-1);
       for n = 0:((colPaddedCbCr/8)-1);
           CbDCTCurrentFrame((m*8)+1:(m+1)*8, (n*8)+1:(n+1)*8) = dct2(CbDCTMatrix((m*8)+1:(m+1)*8, (n*8)+1:(n+1)*8));
           CrDCTCurrentFrame((m*8)+1:(m+1)*8, (n*8)+1:(n+1)*8) = dct2(CrDCTMatrix((m*8)+1:(m+1)*8, (n*8)+1:(n+1)*8));
       end
    end

    

    quantizationValue = 128;
    YQuantized = round(YDCTCurrentFrame/quantizationValue);
    CbQuantized = round(CbDCTCurrentFrame/quantizationValue);
    CrQuantized = round(CrDCTCurrentFrame/quantizationValue);
    

    
    [currentLumaDC, zigZagCurrentLumaAC] = zigZag(YQuantized, indicationMatrix, 2);            
    [currentCbDC, zigZagCurrentCbAC] = zigZag(CbQuantized, indicationMatrix, 1);
    [currentCrDC, zigZagCurrentCrAC] = zigZag(CrQuantized, indicationMatrix, 1);
    

    
    differentialCurrentLumaDC = differentialCoding(currentLumaDC);
    differentialCurrentCbDC = differentialCoding(currentCbDC);
    differentialCurrentCrDC = differentialCoding(currentCrDC); 
  

    
    encoderBufferZigzagLumaAC{1,number-5} = zigZagCurrentLumaAC;
    encoderBufferDifferentialLumaDC{1,number-5} = differentialCurrentLumaDC;
    encoderBufferZigzagCbAC{1,number-5} = zigZagCurrentCbAC;
    encoderBufferDifferentialCbDC{1,number-5} = differentialCurrentCbDC;
    encoderBufferZigzagCrAC{1,number-5} = zigZagCurrentCrAC;
    encoderBufferDifferentialCrDC{1,number-5} = differentialCurrentCrDC;
    encoderBufferMVCurrX{1,number-5} = motionVectorXValue;
    encoderBufferMVCurrY{1,number-5} = motionVectorYValue;
    encoderBufferIndicationMatrix{1,number-5} = indicationMatrix;
    

    
    [reconstructedCurrentLuma, reconstructedCurrentCb, reconstructedCurrentCr] = inbuildDecoder(YQuantized, CbQuantized, CrQuantized, motionVectorXValue, motionVectorYValue, subSampledYReferenceFrame, subSampledCbReferenceFrame, subSampledCrReferenceFrame, indicationMatrix);
    


    upsampledCurrentLuma = reconstructedCurrentLuma;
    

    upsampledCurrentCb = zeros (row, column, 'uint8');  
    upsampledCurrentCr = zeros (row, column, 'uint8');  
    
    upsampledCurrentCb(1:2:end,1:2:end)=reconstructedCurrentCb(1:end,1:end);
    upsampledCurrentCb(2:2:end,:)=upsampledCurrentCb(1:2:end,:);
    upsampledCurrentCb(:,2:2:end)=upsampledCurrentCb(:,1:2:end);
    
    upsampledCurrentCr(1:2:end,1:2:end)= reconstructedCurrentCr(1:end,1:end);
    upsampledCurrentCr(2:2:end,:)=upsampledCurrentCr(1:2:end,:);
    upsampledCurrentCr(:,2:2:end)=upsampledCurrentCr(:,1:2:end);
    

    reconstructedYCbCr = cat(3, upsampledCurrentLuma, upsampledCurrentCb, upsampledCurrentCr);
    

    reconstructedRGB = ycbcr2rgb(reconstructedYCbCr);

    figure();
    imshow(reconstructedRGB);
    title(['Reconstructed Current RGB frame ' int2str(number) ' at ENCODER']);
       

    
    Y_Error = upsampledCurrentLuma - currentFrameY; 

    MSE_Y = sum(sum(Y_Error.^2))/(row*column); 

    PSNR_Y = 10*log10((255.^2)/MSE_Y); 

    display(['Calculated PSNR for Luma component of Current Frame no. ' int2str(number) ' is = ' num2str(PSNR_Y)]);
    
end
