clear all
close all 

Vsn = 3.8539
Vn  = 1.4908

Pvsn = Vsn^2;
Pvn  = Vn^2;


SNR = (Vsn - Vn)/Vn;

SNR_dB = 20*log10(SNR)


SNR = (Pvsn-Pvn)/Pvn

SNR_dB = 10*log10(SNR)