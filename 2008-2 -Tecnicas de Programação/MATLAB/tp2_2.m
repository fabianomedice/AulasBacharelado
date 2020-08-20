clc
clear
a = input ('Digite um numero real: ')
b = input ('Digite outro um numero real: ')
c = input ('Digite outro um numero real: ')
if a>b
    x=a;
    a=b;
    b=x;
end
if a>c
    x=a;
    a=c;
    c=x;
end
if b>c
    x=b;
    b=c;
    c=x;
end
fprintf('os numeros em ordem crescente sao: \n%f\t%f\t%f',a,b,c)