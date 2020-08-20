%Programa para comparar doi numeros
clc;
clear;
A = input ('Digite um numero natural qualquer: ');
B = input ('Digite um outro numero natural qualquer: ');
if A > B
    fprintf ('\n\n%d E O MAIOR NUMERO', A);
else
    if A < B
        fprintf('\n\n%d E O MAIOR NUMERO', B);
    else
        fprintf('\n\nOS NUMERO SAO IGUAIS');
    end
end