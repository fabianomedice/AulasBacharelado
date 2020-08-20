clc;
clear;
x=input('Digite um numero natural ');
div=x;
fprintf('Os divisores de %d sao:\n',x)
while (div>0)
    if mod(x,div)==0
        fprintf('%d\t',div)
    end
    div=div-1;
end