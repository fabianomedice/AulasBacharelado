%%% limpar a tela e a memoria
clear all
clc

% % % % % % %iniciar camera
% % % % % % vid=videoinput('matrox');
% % % % % % vi.FramesPerTrigger=1;
% % % % % % preview(vid)
% % % % % % pause
% % % % % % start(vid)
% % % % % % pause(0.1)
% % % % % % foto=getdata(vid);
foto=imread('barras.JPG');

%discartar dimen�oes da imagem (reescrever imagem apenas em 2D)
aux=size(foto);
for x=1:aux(2)
    for y=1:aux(1)
        img1(y,x)=foto(y, x, 1, 1);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% carregar imagem e transformar em tons de cinza
%img1=imread('numeros.jpg');
%img1=rgb2gray(img1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%% tratamento de imagem %%%%%%
%filtro passa baixa
matr=ones(3,3)/10;
img2=imfilter(img1,matr);



%%% calculo do threshold e binariza�ao
level = graythresh(img1);
img3 = im2bw(img1,level);

%mostrar imagem original, imagem suavizada, imagem binarizada e histograma
subplot(2,2,1)
imshow(img1)
subplot(2,2,2)
imshow(img2)
subplot(2,2,3)
imshow(img3)
subplot(2,2,4)
imhist(img2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% corrigir rota�ao
offset_x=100; % espa�amento do meio da figura
aux=size(img3); % variavel auxiliar (tamanho da figura)
a=round(aux(2)/2); % valor da metade da figura


y=2; % valor inicial para varredura da imagem

%varre a imagem ate a borda no primeiro ponto
while (img3(y,a-offset_x)==1)||(y==aux(1))
    y=y+1;
end
y1=y;


y=2; % valor inicial para varredura da imagem
%varre a imagem ate a borda no segundo ponto
while (img3(y,a+offset_x)==1)||(y==aux(1))
    y=y+1;
end
y2=y;

%calcula angulo
ang=(tan((y2-y1)/(2*offset_x)));

%converte o valor do angulo de radianos para graus
angulo=rad2deg(ang);

%usa fun�ao de rota�ao do matlab
img4=imrotate(img3,angulo,'bilinear','loose');
figure, imshow(img4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% retirar retalhos da borda
%canto inferior esquerdo

%inicializa�ao dos limites para reescrever a imagem
a1=1;%limite minimo de X
b1=1;%limite minimo de Y
a2=1;%limite maximo de X
b2=1;%limite maximo de Y

%hipotese para rota�ao anti horaria
if angulo>0
    x=1; % valor inicial para varredura da imagem
    while img4(aux(1),x)==0 %verredura crescente ate primeiro pixel branco em X
        x=x+1;
    end
    a1=x;%salva valor do limite minimo de X
    
    y=1; % valor inicial para varredura da imagem
    while img4(y,3)==0%verredura crescente ate primeiro pixel branco em Y
        y=y+1;
    end
    b1=y;%salva valor do limite minimo de Y
    
    x=aux(2);% valor inicial para varredura da imagem
    while img4(3,x)==0%verredura decrescente ate primeiro pixel branco em X
        x=x-1;
    end
    a2=x;%salva valor do limite maximo de X
    
    y=aux(1);% valor inicial para varredura da imagem
    while img4(y,aux(2))==0%verredura decrescente ate primeiro pixel branco em Y
        y=y-1;
    end
    b2=y; %salva valor do limite maximo de Y
end

%hipotese para rota�ao horaria
%homologo ao metodo da primeira hipotese
if angulo<0
    x=1;
    while img4(3,x)==0
        x=x+1;
    end
    a1=x;
    
    y=1;
    while img4(y,aux(2))==0
        y=y+1;
    end
    b1=y;
    
    x=aux(2);
    while img4(aux(1),x)==0
        x=x-1;
    end
    a2=x;
    
    y=aux(1);
    while img4(y,3)==0
        y=y-1;
    end
    b2=y;
end

%hipotese para imagem sem rota�ao
if angulo==0
    img5=img4; % transcreve a imagem na integra
else % reescreve a imagem sem bordas utilisando os limites
    c=1;% variavel auxiliar para indice da nova imagem
    for x=a1:a2
        d=1;% variavel auxiliar para indice da nova imagem
        for y=b1:b2
            img5(d,c)=img4(y,x);
            d=d+1;
        end
        c=c+1;
    end
end
figure, imshow(img5)

%%% reconhecer codigo de barras %%%
cbarras