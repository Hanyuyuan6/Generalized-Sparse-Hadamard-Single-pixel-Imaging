function w = Natural_Hadamard_Transform(n)
    w = [1 1; 1 -1];
    
    for N=1:n-1
        Wk = [w w; w -w];
        w = Wk;
    end
end