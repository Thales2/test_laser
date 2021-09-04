clear all
close all

N = 16;
Nfft = 2048*2;

BW  = 20e6;
fs = 1e9;
decim = fs/BW/2;


% Ndata = 102400*N;
Ndata = 2000000;

load('ref.mat')

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


mem = aximaster('Xilinx', ...
    'Interface','UDP', ...
    'DeviceAddress','192.168.0.2');

scope = scopeInit(Ndata);


% capture noise




[s_deltasig, s_ref] = prog_fpga_spread(mem,Nfft,BW);
writememory(mem,0x00000003*8,uint64(0xFFF));
writememory(mem,0x00000000*8,uint64(0x01));



load calib.mat

figure

distance = [];
distance2 = [];

Nwave = 1;
% signalRef = zeros(1,39997);
while(1)
    
    [wave] = scopeCapture(scope,Ndata,1);
    
    wave  = wave - mean(wave);
    signal = resample(wave,1,decim);
        
    Vrms = rms(signal);
   
    [signalOut, W ] = demodulation(signal,s_ref,Nfft/2,N,1);
    
    
    signalOut = sgolayfilt((signalOut),2,7);
    
    
    XC = fft(signalOut);
    [~, idx ] = max(abs(signalOut));
    d_int=idx-1;%delay (integer)
    N_p=numel(signalOut);%number of points
    N_2=N_p/2-1;%number of valid points
    phi_shift_int=-d_int*pi*2/N_p*(1:(N_2));
    W=abs(XC(2:(N_p/2)));%weight
    phi=mod(angle(XC(2:(N_p/2)))-phi_shift_int+pi,2*pi)-pi;%alternate method (faster)
    
    d_frac = (sum((1:(N_2)).*phi.*W.^2)/sum(((1:(N_2)).*W).^2))*(N_p/2)./pi; %fractional delay
    
    delay = d_int - real(d_frac);
    
    distance_temp = delay*0.5*3e8/(fs/decim);
    
    distance = [ distance distance_temp];
    
    if (idx == 1) || (idx == Nfft)
        d_frac2 = 0;
    else
        d_frac2 = (signalOut(idx+1) - signalOut(idx-1) )./( 2*signalOut(idx) - signalOut(idx-1) - conj(signalOut(idx+1)) );
    end
    
    
    
    
    delay2 = d_int + real(d_frac2);
    
   
    
    X = signalOut;
    k = idx;
    tau = @(x) 1/4 * log(3*x^2 + 6*x + 1) - sqrt(6)/24 * log((x + 1 - sqrt(2/3))  /  (x + 1 + sqrt(2/3)));
    ap = (real(X(k + 1)) * real(X(k)) + imag(X(k+1)) * imag(X(k)))  /  (real(X(k)) * real(X(k)) + imag(X(k)) * imag(X(k)));
    dp = -ap / (1 - ap);
    am = (real(X(k - 1)) * real(X(k)) + imag(X(k - 1)) * imag(X(k)) )  /  (real(X(k)) * real(X(k)) + imag(X(k)) * imag(X(k)));
    dm = am / (1 - am);
    d = (dp + dm) / 2 + tau(dp * dp) - tau(dm * dm);
    d2 = k + d;    
    
    [maxValue, d ] = findmax(signalOut);
    
    distance_temp2 = delay2*0.5*3e8/(fs/decim) ;
   
    
    
    distance2 = [ distance2 distance_temp2];
    
    subplot(311)
    plot(signal(1:Nfft))
    title('input signal')
    grid on 
    
    subplot(312)
    plot(abs(signalOut))
    title('detection')
    grid on 
    
    subplot(313)
    pwelch(signal,[],[],Nfft);
    grid on 
    
    
    std(distance2)

    










    key = get(gcf,'CurrentKey');
    if(strcmp (key , 'return'))
        break;
    elseif (strcmp (key , 'r'))
        distance2 = [];
    end
    
    
end


fclose(scope)

% 
% signalRef = signalRef/Nwave;
% 
% save('calib.mat','signalRef')


% [s_deltasig, s_ref] = prog_fpga_spread(mem);
%
% writememory(mem,0x00000000*8,uint64(0x01));
%
%
%
% [wave] = scopeCapture(scope,Ndata,1);
%
% wave  = wave - mean(wave);
%
% signal = resample(wave,1,100);
%
%
% fclose(scope)


% fftBin = zeros(1,Nfft);
% for i = 1:1
%
%     i1 = (i-1)*Nfft+1;
%     i2 = i*Nfft;
%
%
%
%     fftBin = fftBin + fft(signal(i1:i2),Nfft);
% end
%
% ref = ifft(fftBin);
%
% save('ref.mat','ref');




% [signalOut] = demodulation(signal,ref,Nfft/2,1,1);
%
%
% subplot(311)
% plot(signal)
%
% subplot(312)
% plot(abs(fftBin))
%
% subplot(313)
% plot(abs(signalOut))


