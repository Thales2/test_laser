function [signalOut,W] = demodulation(signal,template,Nfreq,Navg,p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a = ceil((1 -p)*Nfreq)+1;
indexFreq = a:(Nfreq*2 -a);
% indexFreq((indexFreq >= (Nfreq-a)) & (indexFreq <= (Nfreq+a))) = [];
% [s ,Wref ] = genWeigth(1234,Nfreq);

Wref = fft(template,2*Nfreq);

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

W_diff = temp;

signalOut = ifft(W_diff,Nfreq*2);


end

