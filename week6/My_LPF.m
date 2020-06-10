function LPF = My_LPF(LPF, filtersize)
    for i = 1:512
        for j = 1:512
            if (i >= 256-filtersize/2) && (i <= 256+filtersize/2) && (j>=256-filtersize/2) && (j<=256+filtersize/2)
                LPF(i,j) = 1;
            else
                LPF(i,j) = 0;
            end
        end
    end
end
