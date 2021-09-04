function [signalOut,delayOut] = demodulation4(signal,template,Nfreq,Navg,p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
U = 0;
p = 1;
a = ceil((1 -p)*Nfreq)+1;
indexFreq = a:(Nfreq*2 -a);

% [s ,Wref ] = genWeigth(1234,Nfreq);

Wref = fft(template);

signalOut = zeros( 1, numel(Wref)* 2^U );

delay = zeros(1,Navg);

index = 1;
for i = 1:Navg
    temp = signal(index:(index+2*Nfreq-1));
    W =  fft(temp,2*Nfreq);
    
    ratio(:) = abs(W)./abs(Wref);
    deltaA = angle(W) - angle(Wref);
    
    temp = ratio.*exp(1j*deltaA);
    
    W_diff = zeros(size(temp));
    W_diff(indexFreq) = temp(indexFreq);
    
    
    W_diff2                  = zeros( 1, Nfreq*2 * 2^U);
    W_diff2(1:Nfreq)         = W_diff(1:Nfreq);
    W_diff2((end-Nfreq + 1):end) = temp((Nfreq+1):end);
    
    signalOut = signalOut +  ifft(W_diff2);
    
    
    
    index = index + 2*Nfreq;
end



b = fir1(256,1/4096);

c = filtfilt(b,1,imag(signalOut));


% signalOut = sgolayfilt(signalOut,2,55);

[~, idx ] = max(abs(signalOut));
d_int=idx-1;%delay (integer)



if (idx == 1) || (idx == 2*Nfreq)
    d_frac2 = 0;
else
    d_frac2 = (signalOut(idx+1) - signalOut(idx-1) )./( 2*signalOut(idx) - signalOut(idx-1) - conj(signalOut(idx+1)) );
end


delay = d_int + real(d_frac2);
% delay = d_int;



delayOut = delay / 2^U;














end

