clear all 
close all 

Navg = 16;
Ndata = 2^14;


mem = aximaster('Xilinx', ...
                'Interface','UDP', ...
                'DeviceAddress','192.168.0.2');

scope = scopeInit(Ndata);
            


fsin = linspace(0.1e6,6e6,25);

p2pVal = zeros(size(fsin));

for i = 1:numel(fsin)
    prog_fpga_sin(mem,fsin(i));
    

    
    for j = 1:Navg
        wave = scopeCapture(scope,Ndata,0.5);    
        p2pVal(i) = p2pVal(i) + peak2peak(wave);
    end
    
    p2pVal(i) = p2pVal(i)/Navg;
    
    
end


figure;

plot(fsin/1e6,p2pVal);

fclose(scope);

save('calib.mat','fsin','p2pVal')

