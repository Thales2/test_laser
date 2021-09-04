function [signal ,weight ] = genWeigth_gold(seed,Nfreq,index)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


goldseq = comm.GoldSequence('FirstPolynomial','x^10+x^9+x^5+x^2+1',...
    'SecondPolynomial','x^10+x^9+x^8+x^5+x^4+x^3+x^2+1',...
    'FirstInitialConditions',[0 0 0 0 0 0 0 0 0 1],...
    'SecondInitialConditions',[0 0 0 0 0 0 0 0 0 1],...
    'Index',seed,'SamplesPerFrame',2047);

gold1 = goldseq();

gold1 = gold1*2 -1;

gold1 = [gold1; 1];

r = 2*pi*rand(1,Nfreq);
W = exp(-1j*r);

% W = W.*gold1';

% W(120:136) = 0;
s = ifft(W,Nfreq);

s2 = resample(s,2,1);

s2 = ifft(fft(s2).*fft(gold1'));

n = 0:1:(numel(s2)-1);
fcarrier = 0.25;
acarrier = cos(2*pi*fcarrier.*n) + 1j * sin(2*pi*fcarrier.*n);

s3 = s2.*acarrier;
s4 = real(s3) + imag(s3);

temp = fft(s4,2*Nfreq);

weight = zeros(1,2*Nfreq);
weight(index) = temp(index);

signal = ifft(weight);


end

