clc
clear img codigo largura palavra lido
img=img5;

%%% mostrar imagem a ser trabalada
imshow(img)

%%% iniciar variaveis
n=0;
b=1;
x=1;

%%% pegar dimençoes da imagem e definar a altura onde sera lido
aux=size(img);
h=round(aux(1)/2);

%%% loop para medir a quantidade de pixels pretos e brancos na altura h
while x<aux(2)-10

% loop para pixels brancos
    while (img(h,x)==1)&(x<aux(2))
        n=n+1;
        x=x+1;
    end
% salvar quantidade de pixels no vetor se for diferente de zero
    if n~=0
        largura(b)=n;
        n=0;
        b=b+1;
    end
% loop para pixels pretos    
    while (img(h,x)==0)&(x<aux(2))
        n=n+1;
        x=x+1;
    end
% salvar quantidade de pixels no vetor se for diferente de zero
    if n~=0
        largura(b)=n;
        n=0;
        b=b+1;
    end
end

%%% eliminar margem %%%
% ver quais medidas sao falsas antes do codigo
a=2;
while largura(a)<11*min(largura)
    a=a+1;
end

% ver ultima medida valida
b=a+1;
while largura(b)<10*min(largura)
    b=b+1;
end


%%% transformar em codigo binario de acordo com largura da faixa
% faixa estreita=0; faixa larga=1
c=1;
for x=a+1:b
    if rem(x-a,10)~=0
        if (largura(x)<=3*min(largura))
            codigo(c)=0;
            c=c+1;
        else
            codigo(c)=1;
            c=c+1;
        end
    end
end

%%% interpretar o codigo binario uma palavra de 9 bits por vez
% divisao para obter grupos de 9 bits
for x=1:length(codigo)/9
    aux(2)=x*9;
    aux(1)=aux(2)-8;
    b=1;
%%% salvar os nove bits no vetor palavra
    for a=aux(1):aux(2)
    palavra(b)=codigo(a);
    b=b+1;
    end
    reconhece
end
%%% mostrar na tela os caracteres lidos
lido


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%largura -> vetor contendo a espessura de cada faixa                      %
%codigo -> vetor binario representativo das faixas                        %
%palavra -> vetor binario com a palavra de 9 bits referente a 1 caracter  %
%lido -> vetor contendo todos os caracteres lido                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%