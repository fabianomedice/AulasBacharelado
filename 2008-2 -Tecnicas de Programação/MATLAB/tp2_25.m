clc
clear
x= input('Digite o tempo em segundos ');
H = x / 3600;
H = fix(H);
M = mod(x,3600)/60;
M = fix(M);
S = mod(x,60);
fprintf('A conversao em Hora:Minuto:Segundo eh %d:%d:%d', H, M, S); 