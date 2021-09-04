clear all 
% close all

% https://en.wikipedia.org/wiki/Pulse_compression
% Stepped-frequency waveform

% fractional delay estimation 
% https://www.mathworks.com/matlabcentral/fileexchange/25210-subsample-delay-estimation

% fft averaging
% https://flylib.com/books/en/2.729.1/averaging_multiple_fast_fourier_transforms.html
rng(1234)

noise = 1e-7;

fs = 100e6;

N = 512;
r = 2*pi*rand(1,N);
% r = 0.5*ones(1,N);
W = exp(-1j*r);
% W(120:136) = 0;
s = ifft(W,N);

s2 = resample(s,2,1);
n = 0:1:(numel(s2)-1);
fcarrier = 0.25;
acarrier = cos(2*pi*fcarrier.*n) + 1j * sin(2*pi*fcarrier.*n);

s3 = s2.*acarrier;
s4 = real(s3) + imag(s3);

W4 = fft(s4);


%% channel

rng('default')

s5 = [zeros(size(s4)) s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 ]*(1/50^2);


% s5 = [ s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4];

d = -5e-09 / sqrt(2) ;
% d = 0;
nfft = 2^nextpow2(2*numel(s5));
fax = (-nfft/2:nfft/2-1)/nfft;
shft = exp(-1j*d*2*pi*fax);
shft = ifftshift(shft);
fsd = fft(s5,nfft); 
fsd = fsd.*shft; 
dum = ifft(fsd);

s5 = real(dum);




% s5 = s5 + [zeros(1,400) s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 s4 zeros(1,624)]*(1/100^2);
s_noise = noise.*randn(size(s5));
signal = s5;

s5 = signal + s_noise; 


n_rms = sqrt(sum(s_noise.^2)/numel(s_noise));
s_rms = sqrt(sum(signal.^2)/numel(signal));

SNR_db = 20*log10(s_rms/n_rms)

%% doppler
% n = 0:1:(numel(s5)-1);
% df = 2e3/100e6;
% d_shift = exp(-1j*2*pi*df*n);
% s5 = s5.*d_shift;


%% reception 
Navg    = 4;
index = 100;


W7 = zeros(1,2*N);
for i = 1:Navg
    s6 = s5(index:(index+2*N-1));
    W7 = W7 + fft(s6,2*N);
    index = index + 2*N;
end

W7 = W7 ./ Navg;




ratio(:) = abs(W7)./abs(W4);
deltaA = angle(W7) - angle(W4);
W_diff = ratio.*exp(1j*deltaA);
s_diff = fft(W_diff,N*2);
plot(real(s_diff)./max(abs(real(s_diff))))

xc = s_diff;
XC = fft(xc);

[~, idx ] = max(real(xc));
d_int=idx-1;%delay (integer)
N_p=numel(xc);%number of points
N_2=N_p/2-1;%number of valid points
phi_shift_int=-d_int*pi*2/N_p*(1:(N_2));
W=abs(XC(2:(N_p/2)));%weight
phi=mod(angle(XC(2:(N_p/2)))-phi_shift_int+pi,2*pi)-pi;%alternate method (faster)

d_frac = (sum((1:(N_2)).*phi.*W.^2)/sum(((1:(N_2)).*W).^2))*(N_p/2)./pi; %fractional delay

delay = d_int + d_frac

exposition = (Navg.*2*N*1/fs)/1e-6



crest_db = 20*log10(max(real(s_diff))/sqrt(sum(real(s_diff).^2)/numel(s_diff)))

delta = (98.999745938891692 - delay)*1.5
