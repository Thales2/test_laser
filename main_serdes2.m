clear all
close all

% rng(1234)

addpath(genpath('delsig'));


Ntrial = 1000;

Nfreq       = 512;
BW          = 0.5e6;
Nrep        = 8;
p           = 1;
deltaSigmaFreq = 50e6;
delay       = [50000 50001];
fcut1       = 500e6;
fcut2       = 10e6;

SNR_dB = 100;

fs = 2*BW;

OSR = deltaSigmaFreq/fs;

[t,signal, ref] = modulation(Nfreq,BW,Nrep,p);

[~, s_ref, ref_delta] = deltaSigMod(ref,fs,deltaSigmaFreq,4,0);

[t_sig, s_filter, s_deltasig] = deltaSigMod(signal,fs,deltaSigmaFreq,4,0);

s_deltasig = repelem(s_deltasig,100);


distance1 = zeros(Ntrial,numel(delay));
distance2 = zeros(Ntrial,numel(delay));

for k = 1:numel(delay)
    
    s_deltasig_t = [zeros(1,delay(k)) s_deltasig(1:(end-delay(k)))];
    
    for i=1:Ntrial
        
        SNR = 10^(SNR_dB/20);
        
        sPower = rms(s_deltasig_t);
        s_noise = (sPower/SNR).*randn(size(s_deltasig_t));
        s_deltasig_s = s_deltasig_t + s_noise;
        
        [B,A] = butter(1,2*fcut1/(deltaSigmaFreq*100));
        v2    = filter(B,A,s_deltasig_s);
        v3    = v2(1:100:end);
        
        v3 = sign(v3);
        
        [B,A] = butter(4,1/OSR,'low');
        v4 = filter(B,A,v3);
        v4 = v4(1:OSR:end);
        
        signalOut = demodulation(v4,s_ref,Nfreq,Nrep/2,p);
        
        figure
        plot(abs(signalOut))
        
        
        
        XC = fft(signalOut);
        [~, idx ] = max(real(signalOut));
        d_int=idx-1;%delay (integer)
        N_p=numel(signalOut);%number of points
        N_2=N_p/2-1;%number of valid points
        phi_shift_int=-d_int*pi*2/N_p*(1:(N_2));
        W=abs(XC(2:(N_p/2)));%weight
        phi=mod(angle(XC(2:(N_p/2)))-phi_shift_int+pi,2*pi)-pi;%alternate method (faster)
        
        d_frac = (sum((1:(N_2)).*phi.*W.^2)/sum(((1:(N_2)).*W).^2))*(N_p/2)./pi; %fractional delay
        
        
        d_frac2 = (signalOut(idx+1) - signalOut(idx-1) )./( 2*signalOut(idx) - signalOut(idx-1) - conj(signalOut(idx+1)) );
        
        
        delay1 = d_int - d_frac;
        
        delay2 = d_int + real(d_frac2);
        
        distance1(i,k) = delay1*0.5*3e8/fs;
        distance2(i,k) = delay2*0.5*3e8/fs;
        i
        k
    end
end

abs(mean(distance2(:,1)) - mean(distance2(:,2)))/1e-3
std(distance2)/1e-3

% delay = d_int - d_frac;
%
% distance = delay*0.5*3e8/fs;
%
% deltaDistance_mm = abs(distance -  2.137953049656230e-04)/1e-3
%
% crest = max(abs(signalOut))/rms(signalOut);
% crest_dB = 20*log10(crest)

