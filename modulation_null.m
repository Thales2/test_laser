function [t,signal,ref2] = modulation_null(Nfreq,BW,Nrep,p,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fs = 2*BW; 

a = ceil((1 -p)*Nfreq)+1;
index = a:(Nfreq*2 -a);

[ref ,~ ] = genWeigth2(1234,Nfreq,index);



ref2 = ref;

Wref = fft(ref);

if numel(varargin) == 1
    W = varargin{1};
else
    W = ones(size(ref));
end


Wref = Wref.*W;


ref = ifft(Wref);

ref = (ref./max(abs(ref)))*0.25;

signal = repmat(ref,1,Nrep);
t = (0:(numel(signal)-1))*(1/fs);
return;



end

