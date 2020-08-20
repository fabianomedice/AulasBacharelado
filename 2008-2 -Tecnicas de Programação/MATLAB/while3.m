clc;
clear;
N = input ('Digite o numero de elementos da serie : ');
SOMA = 0;
i=0;
while i<= N
    SOMA = SOMA + 1/2^i;
    i=i+1;
end
fprintf ('A soma da serie eh %f',SOMA);