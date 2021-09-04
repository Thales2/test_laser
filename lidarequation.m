
fs = 100e6;

Pt = 1e-3;
% AL = 
c = 3e8;
tau = 1/fs;
R = 300;
sigma = 1;
A = 1;
beta = 0.1;


Pr = Pt*((c*tau)/2)*beta*A/R^4

i = sqrt(2*Pr)*10e3