clc
close all
clear all

%Lendo imagens de um arquivo
foto=imread('teste.JPG');

% % % % % %Mostra a figura a qual estamos trabalhando
% % % % % figure
% % % % % imshow(foto)
% % % % % title ('Foto original')

%Carregar imagem e transformar em tons de cinza
img1=foto;
img1=rgb2gray(img1);

% % % % % %Mostra a figura em tons de cinza
% % % % % figure
% % % % % imshow(img1)
% % % % % title ('Foto em Tons de Cinza')

%Calculo do threshold global
level = graythresh(img1)
img2 = im2bw(img1,level);

%Mostra a figura binarizada globalmente
figure
imshow(img2)
title ('Threshold Global')

%Calculo do threshold global meu
tamanho = size(img1);
img3=img1;

%Pegando o brilho médio da foto
z=1;
i=1;
while i~=tamanho(1)
    j=1;
    while j~=tamanho(2)
        brilho(z)=img1(i,j);
        z=z+1;
        j=j+1;
    end
    i=i+1;
end
media_brilho_foto=mean(brilho);
clear brilho

z=1;
i=1;
while i~=tamanho(1)
    j=1;
    while j~=tamanho(2)
        if img1(i,j)>=media_brilho_foto
            img3(i,j)=255;  %recebe brilho
        else
            img3(i,j)=0;  %não recebe brilho
        end
        z=z+1;
        j=j+1;
    end
    i=i+1;
end

level2 = graythresh(img3)
img4 = im2bw(img3,level);

%Mostra a figura binarizada globalmente
figure
imshow(img4)
title ('Threshold Global Meu')