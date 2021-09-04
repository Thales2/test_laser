clear all 
close all 

addpath(genpath('delsig'));

Nfreq       = 1024;
BW          = 20e6;
Nrep        = 4;
p           = 1;
deltaSigmaFreq = 100e9;
delay       = 0;

fs = 2*BW;

[t,signal1, ref1] = modulation(Nfreq,BW,Nrep,p);
[t,signal2, ref2] = modulation(Nfreq,BW,Nrep,p);


%% hack
goldTest;

ref_1 = ifft(fft(ref1).*fft(gold1',numel(ref1)));
ref_2 = ifft(fft(ref2).*fft(gold2',numel(ref2)));

% signal = repmat(ref_1,1,Nrep) + repmat(ref_2,1,Nrep);

signal = repmat(ref_1,1,Nrep);



%%
% [~, s_ref, ~] = deltaSigMod(ref,fs,deltaSigmaFreq,4,0);
% [t_sig, s_filter, s_deltasig] = deltaSigMod(signal,fs,deltaSigmaFreq,4,delay);


% Channel
SNR_dB = 10;
SNR = 10^(SNR_dB/20);

% sPower = rms(s_filter);


signal = [ zeros(1,200) signal];

% signal = [ zeros(1,200) s_filter];
% s_noise = (sPower/SNR).*randn(size(signal));

% signal = signal + s_noise;

% demodulation 


signalOut = demodulation_gold(signal,ref1,Nfreq,Nrep/2,p,gold1');
signalOut2 = demodulation_gold(signal,ref2,Nfreq,Nrep/2,p,gold2');
figure
plot(abs(signalOut))
hold on 
plot(abs(signalOut2))



XC = fft(signalOut);
[~, idx ] = max(real(signalOut));
d_int=idx-1;%delay (integer)
N_p=numel(signalOut);%number of points
N_2=N_p/2-1;%number of valid points
phi_shift_int=-d_int*pi*2/N_p*(1:(N_2));
W=abs(XC(2:(N_p/2)));%weight
phi=mod(angle(XC(2:(N_p/2)))-phi_shift_int+pi,2*pi)-pi;%alternate method (faster)

d_frac = (sum((1:(N_2)).*phi.*W.^2)/sum(((1:(N_2)).*W).^2))*(N_p/2)./pi; %fractional delay

delay = d_int - d_frac


crest = max(abs(signalOut))/rms(signalOut);
crest_dB = 20*log10(crest)


