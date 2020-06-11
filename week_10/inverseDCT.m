function[inverseDCTMatrix] = inverseDCT( Row, Column, DCTMatrix)

[paddedRow, paddedColumn] = size(DCTMatrix);

for i = 0:((paddedRow/8)-1);
   for j = 0:((paddedColumn/8)-1);
      
       paddedInverseDCTMatrix((i*8)+1:(i+1)*8, (j*8)+1:(j+1)*8) = round(idct2(DCTMatrix((i*8)+1:(i+1)*8, (j*8)+1:(j+1)*8)));
       
   end
end

inverseDCTMatrix = paddedInverseDCTMatrix(1:Row, 1:Column);