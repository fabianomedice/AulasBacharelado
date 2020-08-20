%Ler um numero natural e mostrar o algarismo das unidades
A = input ('Digite um numero natural: ');
UNIDADES = mod(A,10);
fprintf('As unidades do numero %d = %d', A, UNIDADES)
