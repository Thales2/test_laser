function  prog_fpga_sin(mem,fsin)


addpath(genpath('delsig'));


Fover = 10e9;
fs    = 156.25e6;
% fsin  = 1e6;
T     = 1/fsin;
N     = ceil(fs/fsin);

t = (0:1:N)/fs;
s = 0.5*sin(2*pi*t*fsin);

Tmax = 2048*64/Fover;


OSR = Fover/fs;

sup = resample(s,OSR,1);
H = synthesizeNTF(5,OSR,1);
v = simulateDSM(sup,H);


% pack into 64 bits word

M = floor(N*OSR/64);

word = uint64(zeros(M,1));

idx = 1;
for i = 1:M
    for j = 1:64
        if v(idx) == 1
            word(i) = bitset(word(i),j);
        end
        idx = idx + 1;
    end
end




            
writememory(mem,0x00000000*8,uint64(0x00));            

writememory(mem,0x00004000*8,word(1:M));

writememory(mem,0x00000002*8,uint64(M));
writememory(mem,0x00000001*8,uint64(0xFFFF));
            
writememory(mem,0x00000000*8,uint64(0x01));

end

