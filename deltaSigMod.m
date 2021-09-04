function [t,signal, s_deltasig] = deltaSigMod(s,fs,fsdelta,forder,delay)

    sampling = fsdelta;
    OSR = sampling/fs;
    
    
    
    sup = resample(s,OSR,1);
    H = synthesizeNTF(5,OSR,1);
    v = simulateDSM(sup,H); 
    
    v  = [ zeros(1, delay) v  ];
    
    [B,A] = butter(forder,1/OSR,'low');



    
    signal = filter(B,A,v);
    t = (0:(numel(signal)-1))*(1/sampling);

    signal = signal(1:OSR:end);
    
    s_deltasig = v;

end

