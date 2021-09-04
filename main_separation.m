clear all 
close all 

addpath(genpath('delsig'));

rng(12345)
goldTest;

Nfreq       = 1024;
BW          = 50e6;
Nrep        = 1;
p           = 1;
deltaSigmaFreq = 100e9;
delay       = 0;

fs = 2*BW;

[t,signal1, ref1] = modulation( Nfreq, BW, Nrep, p );
[t,signal2, ref2] = modulation( Nfreq, BW, Nrep, p );
% signal2 = signal1;
% ref2 = ref1;

%% 
% [t,signal3, ref3] = modulation_gold( Nfreq, BW, Nrep, p, 5 );
% [t,signal4, ref4] = modulation_gold( Nfreq, BW, Nrep, p, 25 );


signal = signal1 + signal2;
signal = real(signal);
% signal = signal1;
% signal_gold = signal3 + signal4;






ref_1 = ifft(fft(gold1,numel(ref1)));
ref_2 = ifft(fft(gold2,numel(ref2)));

signal_gold_only = repmat(ref_1,1,1) + repmat(ref_2,1,1);





%%
% [~, s_ref, ~] = deltaSigMod(ref,fs,deltaSigmaFreq,4,0);
% [t_sig, s_filter, s_deltasig] = deltaSigMod(signal,fs,deltaSigmaFreq,4,delay);


% Channel
SNR_dB = 40;
SNR = 10^(SNR_dB/20);

sPower = rms(signal);


% signal      = [ zeros(1,200) signal];
% signal_gold = [ zeros(1,200) signal_gold];
% signal_gold_only = [ zeros(1,200) signal_gold_only'];




% signal = [ zeros(1,200) s_filter];
s_noise = (sPower/SNR).*randn(size(signal));

signal = signal + s_noise;
signal_gold_only = signal_gold_only + s_noise;

% demodulation 


signalOut       = demodulation2(signal,ref1,Nfreq,Nrep,p);
% signalOut       = signalOut ./max(abs(signalOut));
crest1          = max(abs(signalOut))/mean(abs(signalOut))



signalOut2      = demodulation2(signal,ref2,Nfreq,Nrep,p);
% signalOut2      = signalOut2 ./max(abs(signalOut2));
crest2          = max(abs(signalOut2))/mean(abs(signalOut2))


% crestX1          = max(abs(signalOut))/rms(abs(signalOut2))


% signalOut_gold  = demodulation_gold(signal_gold,ref3,Nfreq,Nrep/2,p,[]);
% signalOut_gold  = signalOut_gold ./max(abs(signalOut_gold));
% crest3          = max(abs(signalOut_gold))/rms(abs(signalOut_gold))
% 
% 
% 
% signalOut2_gold = demodulation_gold(signal_gold,ref4,Nfreq,Nrep/2,p,[]);
% signalOut2_gold = signalOut2_gold ./max(abs(signalOut2_gold));
% crest4          = max(abs(signalOut2_gold))/rms(abs(signalOut2_gold))



signalOut1_gold_only                    = ifft( fft(signal_gold_only) .* conj(fft(gold1, 2*Nfreq)) );
signalOut1_gold_only                    = signalOut1_gold_only ./max(abs(signalOut1_gold_only));
crest5                                  = max(abs(signalOut1_gold_only))/mean(abs(signalOut1_gold_only))


signalOut2_gold_only                    = ifft( fft(signal_gold_only) .* conj(fft(gold2, 2*Nfreq)) );
signalOut2_gold_only                    = signalOut2_gold_only ./max(abs(signalOut2_gold_only));
crest6                                  = max(abs(signalOut2_gold_only))/mean(abs(signalOut2_gold_only))



% figure
% subplot(221)
% plot(real(signal1))
% hold on 
% plot(real(signal2))
% legend('signal1','signal2')
% title('Methode')
% grid on 
% 
% 
% subplot(223)
% plot(repmat(ref_1,1,1))
% hold on 
% plot(repmat(ref_2,1,1))
% legend('signal1','signal2')
% title('Gold 2047')
% grid on 

signalOut = signalOut./max(abs(signalOut));
signalOut2 = signalOut2./max(abs(signalOut2));


figure
% subplot(211)
plot(abs(signalOut))
hold on 
plot(abs(signalOut2))
title('Methode')

legend(['ch 1 : CF  ' num2str(20*log10(crest1)) ' dB'],['ch 2 : CF  ' num2str(20*log10(crest2)) ' dB'])

grid on 


% subplot(212)
% plot(abs(signalOut1_gold_only))
% hold on 
% plot(abs(signalOut2_gold_only))
% title('Gold 2047')
% 
% legend(['ch 1 : CF  ' num2str(20*log10(crest5)) ' dB'],['ch 2 : CF  ' num2str(20*log10(crest6)) ' dB'])
% 
% grid on 

