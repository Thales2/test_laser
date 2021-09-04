function  [s_deltasig, s_ref] = prog_fpga_zero(mem)


writememory(mem,0x00000000*8,uint64(0x00));       

addpath(genpath('delsig'));










% pack into 64 bits word

M = 1;

word = uint64(zeros(M,1));






            
writememory(mem,0x00000000*8,uint64(0x00));            

writememory(mem,0x00004000*8,word(1:M));

writememory(mem,0x00000002*8,uint64(M-1));
writememory(mem,0x00000001*8,uint64(0xFFFF));
            
writememory(mem,0x00000000*8,uint64(0x01));

end

