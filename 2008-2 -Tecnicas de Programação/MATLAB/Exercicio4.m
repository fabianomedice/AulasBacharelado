%Ler separadamente os tres algarismos de um numero natural (das unidades, das dezenas e das centenas, nessa ordem) e informar qual eh o dobro desse numero
A = input ('Digite as unidades : ');
B = input ('Digite as dezenas : ');
C = input ('Digite as centenas : ');
D = 2*(A+10*B+100*C);
E = A + 10*B + 100*C;
fprintf('O dobro do numero %d = %d',E,D);