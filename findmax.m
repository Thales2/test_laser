function [maxValue, d ] = findmax(signal)


N=length(signal);

shift = linspace(-0.1,0.1,100);
S = fft(signal);

maxValue = zeros(size(shift));
maxIndex = zeros(size(shift));

for i = 1:numel(shift)
    mult = exp(-1i*2*pi./N.*(0:N-1).*shift(i));
    W = S.*mult;
    s = ifft(W);
    [maxValue(i)  maxIndex(i) ] = max( abs(s) );
end


    [~,idx] = max(maxValue);
    d = maxIndex(idx) + shift(idx);
    
end

