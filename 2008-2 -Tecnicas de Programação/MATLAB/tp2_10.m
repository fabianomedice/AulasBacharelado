clc;
clear;
x=input('Digite um numero natural ');
y=input('Digite um outro numero natural maior ');
if mod(x,2)==0
    a=x+2;
else
    a=x+1;
end
while a<y
    fprintf('%d\t',a)
    a=a+2;
end
