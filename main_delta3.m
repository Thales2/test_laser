clear all
close all

addpath(genpath('delsig'));


Ntrial      = 100;
Nfreq       = 2048;
BW          = 100e6;
Nrep        = 8;
p           = 1;
delay       = 500;

fs = 2*BW;

[t,signal, ref] = modulation(Nfreq,BW,Nrep,p);

h = [
 -0.589116077944021 + 0.151476591219555i
  0.588361078953906 + 0.151332091741893i
 -0.348607894997472 + 0.151187236165199i
  0.523335113209466 + 0.151042024830336i
 -1.018912979725726 + 0.150896458078997i
  2.190759877321292 + 0.150750536253717i
 41.228663124329714 + 0.150604259697864i
 46.501135027905804 + 0.150457628755639i
 51.456605832283813 + 0.150310643772080i
 16.466005725653616 + 0.150163305093057i
 -7.281253258130246 + 0.150015613065272i
 -3.871390322863558 + 0.149867568036258i
 -6.455673730731177 + 0.149719170354380i
 -3.557109656653665 + 0.149570420368832i
 -4.396056208420192 + 0.149421318429637i
 -3.131118512949424 + 0.149271864887646i
 -3.409465573710962 + 0.149122060094538i
 -3.001639164040608 + 0.148971904402818i
 -2.699994339106924 + 0.148821398165817i
 -3.023488705410394 + 0.148670541737690i
 -2.839641996990791 + 0.148519335473418i
 -2.267835543038081 + 0.148367779728803i
 -2.755767555077858 + 0.148215874860470i
 -2.088638000293729 + 0.148063621225866i
 -2.140014480779667 + 0.147911019183260i
 -2.276635161677548 + 0.147758069091738i];

timeSampling = Nfreq*Nrep*(1/fs)

% Channel
SNR_dB = linspace(-40,20,40);

distance1_std = zeros(numel(SNR_dB),1);
distance2_std = zeros(numel(SNR_dB),1);

for k=1:numel(SNR_dB)
    
    SNR = 10^(SNR_dB(k)/10);
    
    sPower = (rms(signal)^2)/2;
    
    distance1 = zeros(Ntrial,numel(delay));
    distance2 = zeros(Ntrial,numel(delay));
    
    for i=1:numel(delay)
        
        
        
        for j = 1:Ntrial
            
            signal_d = [ zeros(1,delay(i)) signal];
            
            
            
            p_noise = sPower/SNR;
            v_noise = sqrt(2*p_noise);
            s_noise = (sPower/SNR).*randn(size(signal_d));
            
            signal_n = signal_d + s_noise;
            
            signal_n = signal_n./max(abs(signal_n));
            
            

            
            [signalOut1, delayOut1] = (demodulation2(signal_n,ref,Nfreq,Nrep/2,p));
            %         plot(abs(signalOut))
            
            distance1(j,i) = delayOut1*0.5*3e8/fs;
            %         i
            %         j
            
        end
    end
    distance1_std(k) = std(distance1);
%     k
end


% subplot(211)
% plot(SNR_dB,distance2_std)
% grid on 
% 
% subplot(212)
semilogy(SNR_dB,distance1_std)
hold on 
xlabel('SNR')
ylabel('Accuracy (m) (1 std)')
title('50 Mhz bandwidth')
grid on 



