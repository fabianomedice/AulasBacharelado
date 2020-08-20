%programa para verificar se um numero e par ou impar
clc;
clear;
N = input ('Digite um numero natural qualquer: ');
if mod (N,2) == 0
    fprintf('\n\n%d E UM NUMERO PAR',N);
else
    fprintf('\n\n%d Eh UM NUMERO IMPAR',N);
end
