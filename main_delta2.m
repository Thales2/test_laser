clear all
close all

addpath(genpath('delsig'));

Ntrial      = 100;
Nfreq       = 2048;
BW          = 100e6;
Nrep        = 2;
p           = 1;
delay       = 500;

fs = 2*BW;

[t,signal, ref] = modulation(Nfreq,BW,Nrep,p);

timeSampling = Nfreq*Nrep*(1/fs)

% Channel
SNR_dB = linspace(-40,60,40);

distance1_std = zeros(numel(SNR_dB),1);
distance2_std = zeros(numel(SNR_dB),1);
distance3_std = zeros(numel(SNR_dB),1);
distance4_std = zeros(numel(SNR_dB),1);

distance1_mean = zeros(numel(SNR_dB),1);
distance2_mean = zeros(numel(SNR_dB),1);
distance3_mean = zeros(numel(SNR_dB),1);
distance4_mean = zeros(numel(SNR_dB),1);

for k=1:numel(SNR_dB)
    
    SNR = 10^(SNR_dB(k)/20) ;
    
    sPower = rms(signal);
    
    distance1 = zeros(Ntrial,numel(delay));
    distance2 = zeros(Ntrial,numel(delay));
    distance3 = zeros(Ntrial,numel(delay));
    distance4 = zeros(Ntrial,numel(delay));
    
    for i=1:numel(delay)
        
        
        
        for j = 1:Ntrial
            
            signal_d = [ zeros(1,delay(i)) signal];
                        

            s_noise = (sPower/SNR).*randn(size(signal_d));
            
            signal_n = signal_d + s_noise;
            
            signal_n = signal_n./max(abs(signal_n));
            
            
            signal_sat = signal_n;
            for z = 1:numel(signal_sat)
                if abs(signal_sat(z)) >= 0.8
                    signal_sat(z) = abs(signal_sat(z));
                end 
            end
            
            [signalOut1, delayOut1] = (demodulation5(signal_n,ref,Nfreq,Nrep/2,p));
            [signalOut2, delayOut2] = (demodulation2(signal_n,ref,Nfreq,Nrep/2,p));
            %         plot(abs(signalOut))
            
            distance1(j,i) = delayOut1*0.5*3e8/fs;
            distance2(j,i) = delayOut2*0.5*3e8/fs;

            for z = 1:numel(signal_sat)
                if abs(signal_sat(z)) >= 0.5
                    signal_sat(z) = abs(signal_sat(z));
                end 
            end
            
            [signalOut3, delayOut3] = (demodulation5(signal_sat,ref,Nfreq,Nrep/2,p));
            
            distance3(j,i) = delayOut3*0.5*3e8/fs;
            

            for z = 1:numel(signal_sat)
                if abs(signal_sat(z)) >= 0.3
                    signal_sat(z) = abs(signal_sat(z));
                end 
            end
            
            [signalOut4, delayOut4] = (demodulation5(signal_sat,ref,Nfreq,Nrep/2,p));
            
            distance4(j,i) = delayOut4*0.5*3e8/fs;            
            
            
        end
    end
    distance1_std(k) = std(distance1);
    distance2_std(k) = std(distance2);
    distance3_std(k) = std(distance3);
    distance4_std(k) = std(distance4);
    

    distance1_mean(k) = mean(distance1);
    distance2_mean(k) = mean(distance2);
    distance3_mean(k) = mean(distance3);
    distance4_mean(k) = mean(distance4);    
    
%     k
end


% subplot(211)
% plot(SNR_dB,distance2_std)
% grid on 
% 
subplot(211)
semilogy(SNR_dB,distance1_std)
hold on 
semilogy(SNR_dB,distance2_std)
% semilogy(SNR_dB,distance3_std)
% semilogy(SNR_dB,distance4_std)
% xlabel('SNR')
ylabel('Accuracy (m) (1 std)')
title('50 Mhz bandwidth accuracy')
grid on 
legend('No saturation','Saturation 80%','Saturation 50%','Saturation 30%')


subplot(212)
semilogy(SNR_dB,distance1_mean)
hold on 
semilogy(SNR_dB,distance2_mean)
% semilogy(SNR_dB,distance3_mean)
% semilogy(SNR_dB,distance4_mean)
xlabel('SNR')
ylabel('distance (m)')
title('50 Mhz bandwidth distance')
grid on 
legend('No saturation','Saturation 80%','Saturation 50%','Saturation 30%')




