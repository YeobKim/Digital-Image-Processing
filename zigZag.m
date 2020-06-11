function [DCMatrix, ACMatrix] = zigZag(inputMatrix, indicationIndex, index)

[rowZigZag, columnZigZag] = size(inputMatrix);

% Calculates total non zero elements of indicationIndex matrix, which will
% determine number of DC and AC coefficients.
preventCount = nnz(indicationIndex);

% Intializes matrix to store DC coefficients. 
DCCoeffCount = (rowZigZag/(8*index))*(columnZigZag/(8*index))- preventCount;
DCMatrix = zeros(1, DCCoeffCount, 'double');

% Intializes matrix to store AC coefficients.
ACCoeffCount = (rowZigZag*columnZigZag) - DCCoeffCount - preventCount*64*index*index;
ACMatrix = zeros(1, ACCoeffCount, 'double');

temp = 0;

for x = 0:((rowZigZag/(8*index))-1);
    for y = 0:((columnZigZag/(8*index))-1);
        if(indicationIndex(x+1,y+1) ~= 1)
            % Extracts 8x8 block which needs to be processed.
            block = inputMatrix((x*8*index)+1:(x+1)*8*index, (y*8*index)+1:(y+1)*8*index); 

            % Algorithm for Zig-Zag scan.
            row=1;
            column=2;
            count=0;
            loopCount = 0;
            while ((row <= (8*index) && column <(8*index))||(row <(8*index) && column <= (8*index)))        
                i=row;
                j=column;
                if(i<j)
                   while(j>0 && i<(8*index+1) )
                        zigZagMatrix(1,count+1) = block(i,j);
                        count = count+1;
                        i=i+1;
                        j=j-1;
                    end
                    if(i>8*index)
                        i=8*index;
                        loopCount = loopCount +1;
                        j = loopCount;
                    end
                    j = j+1;
                end

                if(i>j)

                    while(i>0 && j<(8*index+1))
                        zigZagMatrix(1,count+1) = block(i,j);
                        count = count+1;
                        i=i-1;
                        j=j+1;
                    end
                    if(j>8*index)
                        j=8*index;
                        loopCount = loopCount +1;
                        i = loopCount;
                    end
                    i = i+1;
                end
                row = i;
                column = j;
            end
            zigZagMatrix(1,count+1) = block(row,column);

            % Stores DC value of this MB.
            DCMatrix(1,temp+1) = block(1,1);

            % Stores the value in AC matrix.
            ACMatrix(1,((temp)*(64*index*index-1)+1):((temp+1)*(64*index*index-1))) = zigZagMatrix;
            temp = temp + 1;
        end
    end
end