function [outputDC] = differentialCoding(inputDC)

[inputRow, inputColumn] = size(inputDC);
outputDC = zeros(inputRow, inputColumn, 'double');

for m = (1:inputRow*inputColumn);
        if(m==1)
            outputDC(1,m) = inputDC(1,m);
        else
            outputDC(1,m) = inputDC(1,m-1)-inputDC(1,m);
        end
end