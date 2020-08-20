%Ler um numero natural e mostrar o algarismo das centenas, o das dezenas e o das unidades.
A = input ('Digite um numero natural: ');
UNIDADES = mod (A,10);
DEZENAS = (mod (A,100) -  UNIDADES)/10;
CENTENAS = (mod (A,1000) - DEZENAS*10 - UNIDADES)/100;
fprintf ('O numero %d tem %d unidades, %d dezenas e %d centenas', A,UNIDADES,DEZENAS,CENTENAS);