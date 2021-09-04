clear all 
close all

N = 64;
noiseP = 0.001;
peakPowerMax = 400;
AvrPowerMax  = 0.001;
energie = 1;


tc = gauspuls('cutoff',50e6,0.6,[],-40); 
t = -tc*10 : 1e-9 : 10*tc; 
[yi,yq,ye] = gauspuls(t,50e6,0.6); 


e = sum(ye.^2);
ye = ye./e^0.5;

plot(t,ye)


signal = zeros(size(ye));
noise  = zeros(size(ye));
for i=1:N
    noise = noise + (noiseP^0.5).*randn(size(ye));    
    signal = signal + ye;
end

signal = (signal + noise);


plot(signal)


% noise = (noiseP^0.5).*randn(size(ye));
xrms = sqrt(sum(noise.^2)/numel(noise));
crestFactor = (max(signal)/(xrms))


% % peak power condition 
% ye = sqrt(400)*(ye ./ max(ye));
% 
% % average power condition 
% AveragePower = (1/numel(ye)) * sum(ye.^2);
% 
% N = ceil(AveragePower / AvrPowerMax);
% 
% noise = (noiseP^0.5).*randn(size(ye));
% ye = ye + noise;
% plot(t,ye)


% noiseP = 0.000001;
% 
% 
% tc = gauspuls('cutoff',50e6,0.6,[],-40); 
% t = -tc*10 : 1e-9 : 10*tc; 
% [yi,yq,ye] = gauspuls(t,50e6,0.6); 
% 
% 
% AveragePower = (1/numel(ye)) * sum(ye.^2);
% ye = (power^0.5).*(ye./sqrt(AveragePower));
% noise = (noiseP^0.5).*randn(size(ye));
% ye = ye + noise;
% 
% plot(t,ye)
% 
% xrms = sqrt(sum(noise.^2)/numel(noise));
% crestFactor = max(ye)/(xrms/sqrt(N))

