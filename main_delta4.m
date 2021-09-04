clear all
close all

addpath(genpath('delsig'));

Ntrial      = 200;
Nfreq       = 2048;
BW          = 100e6;
Nrep        = 8;
p           = 1;
delay       = 500;

fs = 2*BW;

[t,signal, ref] = modulation(Nfreq,BW,Nrep,p);

timeSampling = Nfreq*Nrep*(1/fs)

% Channel
SNR_dB = linspace(60,60,40);

distance1_std = zeros(numel(SNR_dB),1);
distance2_std = zeros(numel(SNR_dB),1);

for k=1:numel(SNR_dB)
    
    SNR = 10^(SNR_dB(k)/20) ;
    
    sPower = rms(signal);
    
    distance1 = zeros(Ntrial,numel(delay));
    distance2 = zeros(Ntrial,numel(delay));
    
    for i=1:numel(delay)
        
        
        
        for j = 1:Ntrial
            
            signal_d = [ zeros(1,delay(i)) signal];
                        

            s_noise = (sPower/SNR).*randn(size(signal_d));
            
            signal_n = signal_d + s_noise;
            
            signal_n = signal_n./max(abs(signal_n));
            
            
            signal_sat = signal_n;
%             for z = 1:numel(signal_sat)
%                 if abs(signal_sat(z)) >= 0.5
%                     signal_sat(z) = abs(signal_sat(z));
%                 end 
%             end
            
            [signalOut1, delayOut1] = demodulation4(signal_n,ref,Nfreq,Nrep,1);
            [signalOut2, delayOut2] = demodulation4(signal_sat,ref,Nfreq,Nrep,1);
            %         plot(abs(signalOut))
            
            distance1(j,i) = delayOut1*0.5*3e8/fs;
            distance2(j,i) = delayOut2*0.5*3e8/fs;
            %         i
            %         j
            
        end
    end
    distance1_std(k) = std(distance1);
    distance2_std(k) = std(distance2);
%     k
end


% subplot(211)
% plot(SNR_dB,distance2_std)
% grid on 
% 
% subplot(212)
semilogy(SNR_dB,distance1_std)
hold on 
semilogy(SNR_dB,distance2_std)
xlabel('SNR')
ylabel('Accuracy (m) (1 std)')
title('50 Mhz bandwidth')
grid on 




