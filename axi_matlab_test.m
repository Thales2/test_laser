clear all 
close all

% mem = aximaster('Xilinx', ...
%                 'Interface','JTAG');

mem = aximaster('Xilinx', ...
                'Interface','UDP', ...
                'DeviceAddress','192.168.0.2');

% ddr_offset = 0x80000000;
% rd_d = readmemory(mem,ddr_offset,10)
% writememory(mem,ddr_offset,[10:19])
% rd_d = readmemory(mem,ddr_offset,10)


txMem_offset = 0x00004000;
rxMem_offset = 0x00008000;

txWord = uint64(rand(1,256)*(2^64-1));

% txWord(:) = uint64(0xffffffffffffffff);

writememory(mem,txMem_offset*8,txWord)

rd_d = readmemory(mem,0x8*8,1)

writememory(mem,0x00000001*8,0x00000002);
writememory(mem,0x00000002*8,0x00000400);
writememory(mem,0x00000003*8,0x00000001);
writememory(mem,0x00000004*8,0x00000800);

writememory(mem,0x00000000,0x00000001);
writememory(mem,0x00000000,0x00000000);


rd_d = dec2hex(readmemory(mem,0x0,16))

rd_d = dec2hex(readmemory(mem,rxMem_offset*8,256))


            




