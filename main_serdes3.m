clear all
close all

% rng(1234)

addpath(genpath('delsig'));


Ntrial = 1000;

Nfreq       = 512;
BW          = 0.5e6;
Nrep        = 8;
p           = 1;
deltaSigmaFreq = 1000e6;
delay       = [50000 30000];
fcut        = 0.2e6;

SNR_dB = 1000000000000000;

fs = 2*BW;

OSR = deltaSigmaFreq/fs;

[t,signal, ref] = modulation(Nfreq,BW,Nrep,p);

[~, s_ref, ref_delta] = deltaSigMod(ref,fs,deltaSigmaFreq,4,0);

[t_sig, s_filter, s_deltasig] = deltaSigMod(signal,fs,deltaSigmaFreq,4,0);



distance1 = zeros(Ntrial);


s_deltasig_t2 = [zeros(1,delay(1)) s_deltasig(1:(end-delay(1)))];

% s_deltasig_t2 = s_deltasig_t2 + [zeros(1,delay(2)) s_deltasig(1:(end-(delay(2))))];

for i=1:Ntrial
    
    SNR = 10^(SNR_dB/20);
    
    sPower = rms(s_deltasig_t2);
    s_noise = (sPower/SNR).*randn(size(s_deltasig_t2));
    s_deltasig_s = s_deltasig_t2 + s_noise;
    
    [B,A] = butter(1,0.5*fcut/deltaSigmaFreq);
    v3   = filter(B,A,s_deltasig_s);
    
    v4 = v3(1:OSR:end);
    
    signalOut = demodulation(v4,ref,Nfreq,Nrep/2,p);
    
    %         figure
    plot(abs(signalOut))
    
    XC = fft(signalOut);
    [~, idx ] = max(real(signalOut));
    d_int=idx-1;%delay (integer)
    
    d_frac2 = (signalOut(idx+1) - signalOut(idx-1) )./( 2*signalOut(idx) - signalOut(idx-1) - conj(signalOut(idx+1)) );
    
    delay2 = d_int + real(d_frac2);
    
    distance1(i) = delay2*0.5*3e8/fs;
    i
end



