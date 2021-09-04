clear all
close all




%% 
N = 1024;
r = 2*pi*rand(1,N);
W = exp(-1j*r);
% W(1:2:end) = 0;
s = ifft(W,N);

% s = upsample(s,2);
% n = 0:1:(numel(s)-1);
% acos = cos(2*pi*0.5.*n);
% s = real(s) .* acos;

% Nf = 64;
% b = firhalfband(Nf,0.49);
% s = filtfilt(b,1,s);

s = [ zeros(1,70) s s s s s s s s s s s s s s s s s zeros(1,300-70)];

s = s.*exp(-j*0.123);

% b = fir1(1024,0.49);
% s = filter(b,1,s);







N2 = 1024;
index = 1;

W2 = fft(s(index:(index+N2-1)));
% W2 = [W2(1:(N/2)) W2((end-(N/2)+1):end)];
W3 = W2(1:(N2/N):end);

ratio(:) = abs(W)./abs(W3);
ratio(isinf(ratio)) = 0;
deltaA = angle(W) - angle(W3); 

W4 = ratio.*exp(1j*deltaA);

plot(abs(fft(W4)))

%%
% https://www.mathworks.com/help/dsp/ref/dsp.channelizer-system-object.html#bvb0qb3-2

% channelizer = dsp.Channelizer(128,'NumTapsPerBand',8);
% 
% channOut = channelizer(s');
% 
% 
% plot(abs(channOut(:,1)))
% hold on 
% plot(abs(channOut(:,2)))
% plot(abs(channOut(:,3)))



