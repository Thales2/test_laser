function [signalOut,delayOut] = demodulation_gold(signal,template,Nfreq,Navg,p,code)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a = ceil((1 -p)*Nfreq)+1;
indexFreq = a:(Nfreq*2 -a);

% [s ,Wref ] = genWeigth(1234,Nfreq);

Wref = fft(template);

signalOut = zeros(size(Wref));

delay = zeros(1,Navg);

index = 1;
for i = 1:Navg
    temp = signal(index:(index+2*Nfreq-1));
    
    if isempty(code)
        W =  fft(temp,2*Nfreq);
    else
        W =  fft(temp,2*Nfreq).*conj(fft(code,2*Nfreq));
    end
    
    ratio(:) = abs(W)./abs(Wref);
    deltaA = angle(W) - angle(Wref);
    
    temp = ratio.*exp(1j*deltaA);
    
    W_diff = zeros(size(temp));
    W_diff(indexFreq) = temp(indexFreq);
    
    signalOut = signalOut +  ifft(W_diff,Nfreq*2);
    
    signalOut = sgolayfilt(signalOut,2,7);
    
    [~, idx ] = max(abs(signalOut));
    d_int=idx-1;%delay (integer)
    
    
    
    if (idx == 1) || (idx == 2*Nfreq)
        d_frac2 = 0;
    else
        d_frac2 = (signalOut(idx+1) - signalOut(idx-1) )./( 2*signalOut(idx) - signalOut(idx-1) - conj(signalOut(idx+1)) );
    end
    
    
    delay(i) = d_int + real(d_frac2);
    
    index = index + 2*Nfreq;
end



delayOut = mean(delay);







end

