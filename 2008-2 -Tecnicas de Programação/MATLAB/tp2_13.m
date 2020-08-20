clc;
clear;
x=input('Digite um numero natural ');
a=1;
soma=0;
while a<=x
   soma = soma+(a)^2;
   a=a+1;
end
fprintf('A soma dos quadrados dos %d primeiros numeros naturais eh %d',x,soma)