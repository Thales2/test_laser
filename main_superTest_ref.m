clear all
close all

N = 16;
Nfft = 512;
Ndata = 64000*N;


% load('ref.mat')


mem = aximaster('Xilinx', ...
    'Interface','UDP', ...
    'DeviceAddress','192.168.0.2');

scope = scopeInit(Ndata);
[s_deltasig, s_ref] = prog_fpga_spread(mem);
writememory(mem,0x00000000*8,uint64(0x00));

figure

fftBin = zeros(1,Nfft);
scale = 0;

for i = 1:1
    writememory(mem,0x00000000*8,uint64(0x01));
    [wave] = scopeCapture(scope,Ndata,1);
    writememory(mem,0x00000000*8,uint64(0x00));
    wave  = wave - mean(wave);
    signal = resample(wave,1,125);
    
    for i = 1:(N/2)

        i1 = (i-1)*Nfft+1;
        i2 = i*Nfft;

        fftBin = fftBin + fft(signal(i1:i2),Nfft);
        scale = scale + 1;
    end

    key = get(gcf,'CurrentKey');
    if(strcmp (key , 'return'))
        break;
    end    
    
    plot(abs(fftBin/scale))
    
end

fclose(scope)

fftBin = fftBin/scale;

ref = ifft(fftBin);

save('ref.mat','ref');



