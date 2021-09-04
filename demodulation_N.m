function [ signalOut, delay ] = demodulation_N(signal,template,Nfreq,Navg,U)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
p =1;
a = ceil((1 -p)*Nfreq)+1;
indexFreq = a:(Nfreq*2 -a);


Wref = fft(template);

W = zeros(1,2*Nfreq);
index = 1;
for i = 1:Navg
    temp = signal(index:(index+2*Nfreq-1));
    W = W + fft(temp,2*Nfreq);
    index = index + 2*Nfreq;
end

W = W ./ Navg;


ratio(:) = abs(W)./abs(Wref);
deltaA = angle(W) - angle(Wref);


temp = ratio.*exp(1j*deltaA);

W_diff = zeros(size(temp));
W_diff(indexFreq) = temp(indexFreq);

% W_diff = temp;


W_diff2                  = zeros( 1, Nfreq*2 * 2^U);
W_diff2(1:Nfreq)         = W_diff(1:Nfreq);
W_diff2((end-Nfreq + 1):end) = temp((Nfreq+1):end);

signalOut               = ifft(W_diff2,Nfreq*2 * 2^U);


[~, idx ]               = max(abs(signalOut));
d_int                   = idx-1;                %delay (integer)



if (idx == 1) || (idx == 2*Nfreq * 2^U)
    d_frac2 = 0;
else
    d_frac2 = (signalOut(idx+1) - signalOut(idx-1) )./( 2*signalOut(idx) - signalOut(idx-1) - conj(signalOut(idx+1)) );
end


delay = d_int + real(d_frac2);

delay = delay / 2^U;

end

