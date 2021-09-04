clear all 
close all 

addpath(genpath('delsig'));

rng(12345)
goldTest;

Nfreq       = 2^10;
BW          = 50e6;
Nrep        = 16;
p           = 1;
deltaSigmaFreq = 100e9;
delay       = 0;

fs = 2*BW;

[t,signal, ref] = modulation( Nfreq, BW, Nrep, p );


signal      = [ zeros(1,round(0.7*Nfreq)) signal]*.5 + [ signal zeros(1,round(0.7*Nfreq)) ];

noise = 0.05*randn(size(signal));

signal      = signal + noise;

[b,a]       = butter(2,[1e6 6e6]/BW);
signal      = filter(b,a,signal);

% [b]       = fir1(32,[2e6 10e6]/BW);
% signal      = filter(b,1,signal);



signalOut   = demodulation2(real(signal),ref,Nfreq,Nrep,p);
% signalOut   = signalOut./max(abs(signalOut));

% 


imp = zeros(1,128);
imp(1) = 1;

h = filter(b,a,imp);
h = h./max(abs(h));


signalOut = filter(h(end:-1:1),1,signalOut);


subplot(211)

plot(real(signal(1:(2*Nfreq+1050))))
grid on


subplot(212)

plot(real(signalOut))
grid on 





