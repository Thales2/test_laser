clear all
close all

sampling = 5e9;
BW = 100e6;
OSR = sampling/BW;

%% 
N = 256;
r = 2*pi*rand(1,N);
W = exp(-1j*r);
s = ifft(W,N);

s = upsample(s,2);
n = 0:1:(numel(s)-1);
acos = cos(2*pi*0.5.*n);
s = real(s) .* acos;

Nf = 128;
b = firhalfband(Nf,0.45);
s = filtfilt(b,1,s);

sup = resample(s,OSR,1);
sup = [sup sup sup sup];


%% delta sigma modulator
H = synthesizeNTF(5,OSR,1);
v = simulateDSM(sup,H); 

[B,A] = butter(4,1/OSR,'low');

vf = filter(B,A,v);
supf = filter(B,A,sup);

figure(1)

subplot(211)
plot(supf)
hold on 
plot(vf)
legend('original','delta sigma')

subplot(212)
plot(abs(supf - vf))



