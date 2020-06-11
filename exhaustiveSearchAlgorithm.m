function [ xShift, yShift, differenceMatrix] = exhaustiveSearchAlgorithm(currentMacroBlock,referenceSearchWindow)

    % Finds loop count.
    [swRow, swColumn] = size(referenceSearchWindow);
    [mbRow, mbColumn] = size(currentMacroBlock);
    rowTraverse = (swRow-mbRow)+1;
    columnTraverse = (swColumn-mbColumn)+1;

    minSAD = 0;
    xShift = 0;
    yShift = 0;
    differenceMatrix = zeros(mbRow, mbColumn,'double');

    %%
    % Sum of Absolute Difference (SAD).
    for p = 1:rowTraverse;
        for q = 1:columnTraverse;
            tempDifferenceMatrix = currentMacroBlock - referenceSearchWindow(p:(p+15),q:(q+15));
            SADValue = sum(sum(abs(tempDifferenceMatrix)));
            % Calculates Min SAD and corresponding diff_matrix and X and Y pixels.
            if ((SADValue < minSAD)||(xShift == 0 && yShift == 0))
                minSAD = SADValue;
                xShift = p;
                yShift = q;
                differenceMatrix = tempDifferenceMatrix;
            end
        end
    end
end