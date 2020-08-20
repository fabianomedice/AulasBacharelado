clc
clear
x = input ('Digite um numero natural: ')
if mod(x,7) == 0
    if mod(x,5) == 0
        fprintf('o numero %d eh divisivel por 7 e 5',x)
    else
        fprintf('o numero %d nao eh divisivel por 7 e 5',x)
    end
else
    fprintf('o numero %d nao eh divisivel por 7 e 5',x)
end