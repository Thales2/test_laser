
goldseq = comm.GoldSequence('FirstPolynomial','x^10+x^9+x^5+x^2+1',...
    'SecondPolynomial','x^10+x^9+x^8+x^5+x^4+x^3+x^2+1',...
    'FirstInitialConditions',[0 0 0 0 0 0 0 0 0 1],...
    'SecondInitialConditions',[0 0 0 0 0 0 0 0 0 1],...
    'Index',5,'SamplesPerFrame',2047);
gold1 = goldseq();

gold1 = gold1*2 -1;


goldseq = comm.GoldSequence('FirstPolynomial','x^10+x^9+x^5+x^2+1',...
    'SecondPolynomial','x^10+x^9+x^8+x^5+x^4+x^3+x^2+1',...
    'FirstInitialConditions',[0 0 0  0 0 0 0 0 0 1],...
    'SecondInitialConditions',[0 0 0  0 0 0 0 0 0 1],...
    'Index',25,'SamplesPerFrame',2047);
gold2 = goldseq();
gold2 = gold2*2 -1;


% figure 
% subplot(311)
% y = ifft(fft(gold1).*conj(fft(gold1)));
% plot(y)
% 
% subplot(312)
% y = ifft(fft(gold2).*conj(fft(gold2)));
% plot(y)
% 
% subplot(313)
% y = ifft(fft(gold1).*conj(fft(gold2)));
% plot(y)

