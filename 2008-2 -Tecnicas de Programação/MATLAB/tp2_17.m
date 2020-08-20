clc;
clear;
a=[1:10];
contador =1;
while contador <11
    a(contador) = input ('Digite o numero \n');
    contador=contador+1;
end

maior=a(1);

contador=1;
while contador<11
    if maior < a(contador)
        maior = a (contador);
    end
    contador=contador+1;
end

contador=1;

menor=a(1);

while contador<11
    if menor > a(contador)
        menor = a (contador);
    end
    contador=contador+1;
end

fprintf ('O maior numero foi %f e o menor foi %f\n',maior,menor)

soma=0;
contador=1;
while contador<11
    soma=soma+a(contador);
    contador=contador+1;
end
media = soma/10;
fprintf('A media aritmetica eh %f \n',media)