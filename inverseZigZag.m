function [resultMatrix] = inverseZigZag( row, column, zigZagDC, zigZagAC, rcvdIndicationMatrix, index)

resultMatrix = zeros(row, column,'double');
invDCVariable = 0;

for rowTraverse = 0:(row/(8*index))-1;
    for columnTraverse = 0:(column/(8*index))-1;
        
        extraMatrix = zeros((8*index),(8*index),'double');
        
        % For now we include block having 0s only. Later on, previous frames value can be used. 
        if(rcvdIndicationMatrix(rowTraverse+1, columnTraverse+1) ~= 1)
            count=0;
            loopCount = 0;
            rowIndex=1;
            columnIndex=2; 
            block = zigZagAC(1,(invDCVariable*(64*index*index -1) +1):(invDCVariable +1)*(64*index*index -1));
            invDCVariable = invDCVariable + 1;
            extraMatrix(1,1) = zigZagDC(1,invDCVariable); 

            while ((rowIndex <= (8*index) && columnIndex <(8*index))||(rowIndex <(8*index) && columnIndex <= (8*index)))        
                m=rowIndex;
                n=columnIndex;
                
                if(m>n)
                    while(m>0 && n<(8*index+1))
                        extraMatrix(m,n) = block(1,count+1);
                        count = count+1;
                        m=m-1;
                        n=n+1;
                    end
                    if(n>(8*index))
                        n=8*index;
                        loopCount = loopCount +1;
                        m = loopCount;
                    end
                    m = m+1;
                end
                
                if(m<n)
                   while(n>0 && m<(8*index+1) )
                        extraMatrix(m,n) = block(1,count+1);
                        count = count+1;
                        m=m+1;
                        n=n-1;
                    end
                    if(m>(8*index))
                        m=8*index;
                        loopCount = loopCount +1;
                        n = loopCount;
                    end
                    n = n+1;
                end

                rowIndex = m;
                columnIndex = n;
            end
            % Counts (8*index,8*index) positioned value.
            extraMatrix(rowIndex,columnIndex) = block(1,count+1);
        end
        resultMatrix((rowTraverse*8*index+1):(rowTraverse+1)*8*index, (columnTraverse*8*index+1):(columnTraverse+1)*8*index) = extraMatrix;
    end
end