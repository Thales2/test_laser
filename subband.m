function [band] = subband( signal, Nfilt )

N = ceil(log2(numel(signal)));
N2 = 2^N;

s = zeros(1,N2);

s(1:numel(signal)) = signal;

n = 0:1:(numel(s)-1);
s = s.*cos(2*pi*0.25*n) + 1j*s.*sin(2*pi*0.25*n);

b  = fir1(Nfilt,0.5,'low');
s = filter(b,1,s);
s = s(1:2:end);



blow  = fir1(Nfilt,0.24,'low');
bhigh = (-1).^(0:Nfilt).*blow;

[band] = subbandrec( s, blow,bhigh, Nfilt );

end


function [band] = subbandrec( signal, blow,bhigh, Nfilt )

    if numel(signal) == 1
        band = (signal);
        
    else
        s_low = filter(blow,1,signal);
        s_lowD = s_low(1:2:end);

        s_high = filter(bhigh,1,signal);
        s_highD = s_high(1:2:end);
        
        band = [ subbandrec(s_lowD,blow,bhigh,Nfilt) subbandrec(s_highD,blow,bhigh,Nfilt) ];
    end

end
