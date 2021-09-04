clear all
close all

addpath(genpath('delsig'));

format long

fs = 100e6;
c = 3e8;
v = 1000*1000/(60*60);
% 
Nfreq       = 8192/2;
p = 1;


[t,signal, ref] = modulation(Nfreq,fs/2,16,p);

[b a] = butter(2,0.99);
signal_hat = filter(b,a,signal);

signal_out1 = demodulation(signal,ref,Nfreq,1,p);
signal_out2 = demodulation(signal_hat,ref,Nfreq,1,p);


subplot(311)
plot(real(signal))

subplot(312)
plot(abs(fft(ref)))

subplot(313)
plot(abs(signal_out1))
hold on 
plot(real(signal_out2))


