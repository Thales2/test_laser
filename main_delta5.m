clear all
close all

addpath(genpath('delsig'));

Ntrial      = 100;
Nfreq       = 512;
BW          = 100e6;
Nrep        = 16;
p           = 1;
delay       = 500;

fs = 2*BW;

[t,signal, ref] = modulation(Nfreq,BW,Nrep,p);

timeSampling = Nfreq*Nrep*(1/fs)

% Channel
SNR_dB = linspace(0,60,40);

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
            
            
            
%             [b,a] = butter(4,[ 0.2 0.5 ] );
%             signal_n = filter(b,a,signal_n);

            
            [signalOut1, delayOut1] = (demodulation5(signal_n,ref,Nfreq,Nrep/2,p));
            [signalOut2, delayOut2] = (demodulation2(signal_n,ref,Nfreq,Nrep/2,p));
            [signalOut3, delayOut3] = (demodulation6(signal_n,ref,Nfreq,Nrep/2,p));
            
            
            signalOut1 = signalOut1/max(abs(signalOut1));
            signalOut2 = signalOut2/max(abs(signalOut2));
            signalOut3 = signalOut3/max(abs(signalOut3));
            
            
            
            figure
            plot(abs(signalOut1))
            hold on 
            plot(abs(signalOut2))
            plot(abs(signalOut3))
            
            
            
            %         plot(abs(signalOut))
            
            distance1(j,i) = delayOut1*0.5*3e8/fs;
            distance2(j,i) = delayOut2*0.5*3e8/fs;
            distance3(j,i) = delayOut3*0.5*3e8/fs;
  
            
            
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
semilogy(SNR_dB,distance3_std)
% semilogy(SNR_dB,distance4_std)
% xlabel('SNR')
ylabel('Accuracy (m) (1 std)')
title('50 Mhz bandwidth accuracy')
grid on 
legend('1','2','3','Saturation 30%')


subplot(212)
semilogy(SNR_dB,distance1_mean)
hold on 
semilogy(SNR_dB,distance2_mean)
semilogy(SNR_dB,distance3_mean)
% semilogy(SNR_dB,distance4_mean)
xlabel('SNR')
ylabel('distance (m)')
title('50 Mhz bandwidth distance')
grid on 
legend('1','2','3','Saturation 30%')




