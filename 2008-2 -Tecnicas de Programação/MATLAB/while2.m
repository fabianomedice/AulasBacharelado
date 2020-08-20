N=input ('Digite um numero inteiro nao negativo: ');
FAT=1;
fprintf('\n\n%d! =',N);
while N>0
    FAT = FAT *N;
    N=N-1;
end
fprintf('%d',FAT);