clear all
close all

addpath(genpath('delsig'));


Ntrial      = 100;
Nfreq       = 512;
BW          = 125e6;
Nrep        = 2;
p           = 1;
delay       = 500;

fs = 2*BW;

[t,signal, ref] = modulation(Nfreq,BW,Nrep,p);


timeSampling = Nfreq*Nrep*(1/fs)

FPS = 1/timeSampling

% Channel
SNR_dB = linspace(-40,60,40);

distance2_std = zeros(numel(SNR_dB),1);

for k=1:numel(SNR_dB)
    
    SNR = 10^(SNR_dB(k)/20);
    
    sPower = rms(signal);
    
    distance1 = zeros(Ntrial,numel(delay));
    distance2 = zeros(Ntrial,numel(delay));
    
    for i=1:numel(delay)
        
        
        
        for j = 1:Ntrial
            
            signal_d = [ zeros(1,delay(i)) signal];
            
            s_noise = (sPower/SNR).*randn(size(signal_d));
            
            signal_n = signal_d + s_noise;
            
            
            signalOut = (demodulation(signal_n,ref,Nfreq,Nrep/2,p));
            %         plot(abs(signalOut))
            
            
            XC = fft(signalOut);
            [~, idx ] = max(real(signalOut));
            d_int=idx-1;%delay (integer)
            N_p=numel(signalOut);%number of points
            N_2=N_p/2-1;%number of valid points
            phi_shift_int=-d_int*pi*2/N_p*(1:(N_2));
            W=abs(XC(2:(N_p/2)));%weight
            phi=mod(angle(XC(2:(N_p/2)))-phi_shift_int+pi,2*pi)-pi;%alternate method (faster)
            
            d_frac = (sum((1:(N_2)).*phi.*W.^2)/sum(((1:(N_2)).*W).^2))*(N_p/2)./pi; %fractional delay
            
            if (idx == 1) || (idx == 2*Nfreq)
                d_frac2 = 0;
            else
                d_frac2 = (signalOut(idx+1) - signalOut(idx-1) )./( 2*signalOut(idx) - signalOut(idx-1) - conj(signalOut(idx+1)) );
            end
            
            delay1 = d_int - d_frac;
            
            delay2 = d_int - real(d_frac2);
            
            distance1(j,i) = delay1*0.5*3e8/fs;
            distance2(j,i) = delay2*0.5*3e8/fs;
            %         i
            %         j
            
        end
    end
    distance2_std(k) = std(distance2);
%     k
end


% subplot(211)
% plot(SNR_dB,distance2_std)
% grid on 
% 
% subplot(212)
semilogy(SNR_dB,distance2_std)
grid on 



