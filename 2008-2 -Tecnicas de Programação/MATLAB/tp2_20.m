clc;
clear;
x=1;
y=0;
sinal=1;
while y/10>=0
    y=y+sinal*(4/x)
    x=x+1
    sinal=-sinal
end
fprintf('O valor de pi eh %f',y)