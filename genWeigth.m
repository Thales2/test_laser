function [signal ,weight ] = genWeigth(seed,Nfreq,index)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

r = 2*pi*rand(1,Nfreq);
% r = 0.5*ones(1,N);
W = exp(-1j*r);

% W(120:136) = 0;
s = ifft(W,Nfreq);

s2 = resample(s,2,1);
n = 0:1:(numel(s2)-1);
fcarrier = 0.25;
acarrier = cos(2*pi*fcarrier.*n) + 1j * sin(2*pi*fcarrier.*n);

s3 = s2.*acarrier;
s4 = real(s3) + imag(s3);

temp = fft(s4,2*Nfreq);

weight = zeros(1,2*Nfreq);
weight(index) = temp(index);

signal = ifft(weight);

% signal = randn(size(weight));

end

