clear all 
close all 

addpath(genpath('delsig'));

BW              = 50e6;
deltaSigmaFreq  = 10e9;
fsin            = 24e6;
N               = 4096;
fcut1           = 4.5e9;
fcut2           = 50e6;

noise  = 0.0000001;

fs = 2*BW;


t = (0:(N-1))*(1/deltaSigmaFreq);
i_signal = 0.5*sin(2*pi*fsin*t);

OSR = deltaSigmaFreq/fs;
H = synthesizeNTF(5,OSR,1);
v = simulateDSM(i_signal,H); 
v = v + noise*randn(size(v));

[B,A] = butter(1,2*fcut1/deltaSigmaFreq);
% B = fir1(16,2*fcut1/deltaSigmaFreq);
% A = 1;
v2 = filter(B,A,v);

v3 = sign(v2);


[B,A] = butter(2,2*fcut2/deltaSigmaFreq);
v4 = filter(B,A,v3);

subplot(211)
plot(v2)

subplot(212)
plot(i_signal)
hold on 
plot(v4)

% OSR = 1000;
% H = synthesizeNTF(5,OSR,1);
% N = 8000;
% fB = ceil(N/(2*OSR)); 
% ftest=floor(10/3*fB);
% u = 0.5*sin(2*pi*ftest/N*[0:N-1]);	% half-scale sine-wave input
% v = simulateDSM(u,H); 

% 
% v2 = repelem(v,1000);
% 
% 
% [B,A] = butter(2,1./OSR);
% 
% v3 = filter(B,A,v2);
% v3 = v3(1:1000:end);
% 
% v4 = sign(v3);
% 
% [B,A] = butter(2,10./OSR);
% output = filter(B,A,v4);
% 
% 
% plot(u)
% hold on 
% plot(output)