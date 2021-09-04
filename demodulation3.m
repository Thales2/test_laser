function [signalOut,delay] = demodulation3(signal,template,Nfreq,Navg,p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a = ceil((1 -p)*Nfreq)+1;
indexFreq = a:(Nfreq*2 -a);

% [s ,Wref ] = genWeigth(1234,Nfreq);

Wref = fft(template);

W = zeros(1,2*Nfreq);
index = 1;
for i = 1:Navg
    temp = signal(index:(index+2*Nfreq-1));
    W = W + fft(temp,2*Nfreq);
    index = index + 2*Nfreq;
end

W = W ./ Navg;


ratio(:) = abs(W)./abs(Wref);
deltaA = angle(W) - angle(Wref);


temp = ratio.*exp(1j*deltaA);

W_diff = zeros(size(temp));
W_diff(indexFreq) = temp(indexFreq);

signalOut = ifft(W_diff,Nfreq*2);

n=length(signalOut);
binFreq=(mod(((0:n-1)+floor(n/2)), n)-floor(n/2))/n;

integerDelay = find(abs(signalOut)==max(abs(signalOut)));
integerDelay=integerDelay(1)-1;

rotN = exp(2i*pi*integerDelay .* binFreq);

uDelayPhase = -2*pi*binFreq;

u = fft(signalOut);
u = u .* rotN;
weight = abs(u); 
constRotPhase = 1 .* weight;
uDelayPhase = uDelayPhase .* weight;
ang = angle(u) .* weight;
r = [constRotPhase; uDelayPhase] .' \ ang.';

fractionalDelay=r(2);

delay = integerDelay + fractionalDelay;

end

