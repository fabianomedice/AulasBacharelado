clc
clear
n = input('Digite um numero natural ');
a = 1;
b = 0;
fprintf('Os primeiros %d numeros da sequencia fibonacci sao\n',n)
contador = 0;
while contador < n
    a = a + b;
    contador = contador + 1;
    fprintf('%d ', a);
    if contador == n
        break;
    end
    b = a + b;
    contador = contador + 1;
    fprintf('%d ', b);
end