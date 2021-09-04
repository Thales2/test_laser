function  [s_deltasig, ref_out] = prog_fpga_spread(mem,Nfft,BW)


writememory(mem,0x00000000*8,uint64(0x00));       

addpath(genpath('delsig'));


Fover = 10e9;

% BW = 4e6;
% BW = 20e6;
Nfreq       = Nfft/2;

fs = 2*BW;


% load('calib.mat');
% 
% p2pVal = p2pVal./max(abs(p2pVal));
% 
% 
% res = fs/(2*Nfreq);
% 
% freq_fft = (0:1:(Nfreq-1))*res/2;
% 
% Vq = interp1(fsin,p2pVal,freq_fft,'linear','extrap');
% 
% v = (1./(Vq));

% W = zeros(1,2*Nfreq);
% 
% W(1:Nfreq) = v;
% W((Nfreq+1):end) = v(end:-1:1);

W = zeros(1,2*Nfreq);
W = ones(size(W));


[t,signal, ref] = modulation(Nfreq,BW,1,1,W);

[~, s_ref, ref_delta] = deltaSigMod(ref,fs,Fover,4,0);
[t_sig, s_filter, s_deltasig] = deltaSigMod(signal,fs,Fover,4,0);

% s_deltasig = repelem(s_deltasig,10);


% pack into 64 bits word

M = numel(s_deltasig)/64;

word = uint64(zeros(M,1));

idx = 1;
for i = 1:M
    for j = 1:64
        if s_deltasig(idx) == 1
            word(i) = bitset(word(i),j);
        end
        idx = idx + 1;
    end
end


ref_out = s_ref;

            
writememory(mem,0x00000000*8,uint64(0x00));            

writememory(mem,0x00004000*8,word(1:M));

writememory(mem,0x00000002*8,uint64(M-1));
writememory(mem,0x00000003*8,uint64(M-1));
writememory(mem,0x00000001*8,uint64(0xFFFF));
            
% writememory(mem,0x00000000*8,uint64(0x01));

end

