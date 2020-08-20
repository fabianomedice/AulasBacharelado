clc;
clear;
a=[1:20];
contador =1;
while contador <21
    a(contador) = input ('Digite a nota do aluno \n');
    while 1
        if a(contador)<0 | a(contador)>100
            a(contador)=input('A nota nao esta entre 0 e 100.\nDigite a nota do aluno denovo\n');
        else
            break;
        end
    end
    contador=contador+1;
end

maior=0;

contador=1;
while contador<21
    if maior < a(contador)
        maior = a (contador);
    end
    contador=contador+1;
end

contador=1;

maior2=0;

while contador<21
    if maior2 < a(contador) & maior2 < maior & a(contador)~=maior
        maior2 = a (contador);
    end
    contador=contador+1;
end

fprintf ('A maior nota foi %f e a 2 maior nota foi %f\n',maior,maior2)

soma=0;
contador=1;
while contador<21
    soma=soma+a(contador);
    contador=contador+1;
end
media = soma/20;
fprintf('A media aritmetica das notas dos 20 alunos foi %f \n',media)

contador=1;
aluno=0;
while contador <21
    if a(contador)>media
        aluno=aluno+1;
    end
    contador=contador+1;
end

fprintf('O numero de alunos que obtiveram notas acima da media foram %d',aluno)