clear all
close all

addpath(genpath('delsig'));

format long

fs = 100e6;
c = 3e8;
v = 1000*1000/(60*60);
% 
Nfreq       = 8192/2;


[t,signal, ref] = modulation_null(Nfreq,fs/2,1,1);

tau = t(end);
tau_hat = (( c - v )/( c + v ) )*tau;

abs(tau - tau_hat)*fs

t_hat = linspace(0,tau_hat,Nfreq*2);
signal_hat = interp1(t,signal,t_hat);


signal_out1 = demodulation(signal,ref,Nfreq,1,1);
signal_out2 = demodulation(signal_hat,ref,Nfreq,1,1);


subplot(411)
plot(real(signal))


subplot(412)
plot(abs(fft(signal_hat)))


subplot(413)
plot(real(signal_out2))


subplot(414)
plot(real(signal_out1) - real(signal_out2) )

