clc
close all
clear all

%Lendo imagens de um arquivo
foto=imread('teste.JPG');

%Mostra a figura a qual estamos trabalhando
figure
imshow(foto)
title ('Foto original')

%Carregar imagem e transformar em tons de cinza
img1=foto;
img1=rgb2gray(img1);

%Mostra a figura em tons de cinza
figure
imshow(img1)
title ('Foto em Tons de Cinza')

%Calculo do threshold global
level = graythresh(img1);
img2 = im2bw(img1,level);

%Mostra a figura binarizada globalmente
figure
imshow(img2)
title ('Threshold Global')

%Calculo do threshold local
tamanho = size(img1);
porcentagem = input('Qual a porcentagem para o threshold local?\n');
tamanho_x = tamanho(2)*porcentagem/100;
tamanho_y = tamanho(1)*porcentagem/100;

img3=img1;
a=0;
while a~=tamanho(2)
    b=0;
    while  b~=tamanho(1)
        %Construção do retângulo para fazer o threshold
        i=1;        
        while (i+a)~=(tamanho_x+a)              %fazer o retangulo andar pela imagem original
            j=1;
            while (j+b)~=(tamanho_y+b)
                imgaux(j,i)=img1(j,i);
                j=j+1;                
            end
            i=i+1;
        end    
        if (i+a)<= tamanho(1)
            if (j+b) <= tamanho(2)
                %Calculo do threshold do retângulo feito
                levelaux = graythresh(imgaux);
                imgaux2 = im2bw(imgaux,levelaux);
                %Pegando o bit do meio do retângulo
                img3((tamanho_y/2)+b,(tamanho_x/2+a))=imgaux2(tamanho_y/2,tamanho_x/2); %pegar o bit do meio da imagem original        
            end
        end
        %Pegando a próxima linha de trabalho
        b=b+1;
    end
    %Pegando a próxima coluna de trabalho
    a=a+1;
end

%Mostra a figura binarizada localmente
figure
imshow(img3)
title ('Threshold Local')