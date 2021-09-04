function i2c_init(mem )

axi_addr = 0x40800000;


switch_addr = 0x74;

sfp_addr    = 0x50;

ch4 = 0x10;


% init i2c
writememory(mem, axi_addr + 0x120,0xFF); % set fifo to 16

reg = readmemory(mem, axi_addr + 0x100, 1 );

end

