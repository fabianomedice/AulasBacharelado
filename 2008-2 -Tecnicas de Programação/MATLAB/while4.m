clc;
clear;
N=5;
fprintf ('N\tSoma dos N primeiros impares');
while N<=50
    Soma=0;
    i=1;
    contador=1;
    while contador<=N
        Soma = Soma + i;
        i = i+2;
        contador = contador+1;
    end
    fprintf('\n%d\t%d',N,Soma);
    N=N+5;
end