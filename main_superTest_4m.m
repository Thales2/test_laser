clear all
close all

N = 16;
Nfft = 2048*2;

BW  = 50e6;
fs = 1e9;
decim = fs/BW/2;


% Ndata = 102400*N;
Ndata = 2000000;

load('ref.mat')



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
    signal - mean(signal);
    
        
    [signalOut, delay ] = demodulation4(signal,s_ref,Nfft/2,N,0);
    
    
       
    distance_temp2 = (delay)*0.5*3e8/(fs/decim) - 2839
    
    
    distance2 = [ distance2 distance_temp2];
    
    figure(1)
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
