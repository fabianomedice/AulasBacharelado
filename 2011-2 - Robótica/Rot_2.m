%%% limpar a tela e a memoria
clear all
clc

%iniciar camera

% foto =imread('vert.bmp');
img1 =imread('+q30.png');
imshow(img1)
%%% calculo do threshold e binarizaçao
% img3=img1;
level = graythresh(img1); %Comentar essa linha caso a imagem seja.bmp
img3 = im2bw(img1,level); %Comentar essa linha caso a imagem seja.bmp


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Limpar a imagen:
%inicializaçao dos limites para reescrever a imagem
aux=size(img3);

    x=1; % valor inicial para varredura da imagem
    y=1;
    while img3(x,y)==1 %verredura crescente
        y=y+1;
        if y==aux(2)
            x=x+1;
            y=1;
        end 
    end
    v1=x;%salva valor do limite minimo de x
   
    x=1; % valor inicial para varredura da imagem
    y=1;
    while img3(x,y)==1%verredura crescente 
        x=x+1;
        if x==aux(1)
            x=1;
            y=y+1;
        end
    end
    h1=y;%salva valor do limite minimo de y
     
    y=aux(2); % valor inicial para varredura da imagem
    x=aux(1);
    while img3(x,y)==1%verredura decrescente 
        y=y-1;
        if y==1
            y=aux(2);
            x=x-1;
        end
    end
    v2=x;%salva valor do limite maximo de x
    
    
    
    y=aux(2); % valor inicial para varredura da imagem
    x=aux(1);
    while img3(x,y)==1%verredura decrescente 
        x=x-1;
        if x==1
            x=aux(1);
            y=y-1;
        end
    end
    h2=y; %salva valor do limite maximo de y

c=1;% variavel auxiliar para indice da nova imagem
    for x=h1:h2
        d=1;% variavel auxiliar para indice da nova imagem
        for y=v1:v2
            img6(d,c)=img3(y,x);
            d=d+1;
        end
        c=c+1;
    end
img3=img6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
repetir=1;
b=0;
while repetir==1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% corrigir rotaçao
    offset_x=50; % espaçamento do meio da figura
    aux=size(img3); % variavel auxiliar (tamanho da figura)
    a=round(aux(2)/2)-b; % valor da metade da figura
    y=2; % valor inicial para varredura da imagem
    %varre a imagem ate a borda no primeiro ponto
    while (img3(y,a-offset_x)==1)
         y=y+1;
    end
    y1=y;

    y=2; % valor inicial para varredura da imagem
    %varre a imagem ate a borda no segundo ponto
    while (img3(y,a+offset_x)==1)
        y=y+1;
    end
    y2=y;
% % 
% %     figure (10)     %Ative para visualisar os pontos escolhidos para a
% %     imshow (img3)   %correcao
% % 
% %     hold on
% %     q = [1:1000];
% %     plot (a-offset_x,q)
% %     plot (a+offset_x,q)
% %     plot (q,y1)
% %     plot (q,y2)

    %calcula angulo
    ang1=(atan((y2-y1)/(2*offset_x)));
   
    offset_x=50; % espaçamento do meio da figura
    aux=size(img3); % variavel auxiliar (tamanho da figura)
    a=round(aux(2)/2.5)-b; 
    y=2; % valor inicial para varredura da imagem
    %varre a imagem ate a borda no primeiro ponto
    while (img3(y,a-offset_x)==1)
         y=y+1;
    end
    y1=y;

    y=2; % valor inicial para varredura da imagem
    %varre a imagem ate a borda no segundo ponto
    while (img3(y,a+offset_x)==1)
        y=y+1;
    end
    y2=y;

%     figure (11)     %Ative para visualisar os pontos escolhidos para a
%     imshow (img3)   %correcao
%     hold on
%     q = [1:1000];
%     plot (a-offset_x,q)
%     plot (a+offset_x,q)
%     plot (q,y1)
%     plot (q,y2)

    %calcula angulo
    ang2=(atan((y2-y1)/(2*offset_x)));
    b=b+10;
    if abs(ang2-ang1)<0.005 || ang2==0 ||ang1==0
        ang=(ang2+ang1)/2;
        repetir=0;
    end
   
end 
%converte o valor do angulo de radianos para graus
angulo=rad2deg(ang);
    
%usa funçao de rotaçao do matlab
img4=imrotate(img3,angulo,'bilinear','loose');
figure, imshow(img4)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% retirar retalhos da borda

%inicializaçao dos limites para reescrever a imagem
aux=size(img4);

%hipotese para imagem sem rotaçao
    if abs(angulo)<1
       img5=img4; % transcreve a imagem na integra
    
    else % Calculando limites:
        x=1;
        while img4(3,x)==0 %procura o primeiro ponto branco nas primeiras 
            x=x+1;         %linhas horizontais de pixels da imagem,
        end  
        n1=x;              %com o ponto encontrado
        x=3+1;
        while img4(x,n1)==1 %trace uma linha vertical do ponto ate 
            x=x+1;          %o primeiro pixel preto, encontrando assim 
        end                 %o limite superior do codigo.
        a1=x;
    
    
        y=1;
        while img4(y,3)==0 % maneira analoga ao limite superior
            y=y+1;
        end
        m1=y;
        y=3+1;
        while img4(m1,y)==1
            y=y+1;
        end
        b1=y;
    
    
        x=1;
        while img4(aux(1)-3,x)==0
            x=x+1;
        end
        n2=x;
        x=aux(1)-3-1;
        while img4(x,n2)==1
            x=x-1;
        end
        a2=x;
    
        y=1;
        while img4(y,aux(2)-3)==0
            y=y+1;
        end
        m2=y;
    
        y=aux(2)-3-1;
        while img4(m2,y)==1
            y=y-1;
        end
        b2=y;
    
    
        c=1;% variavel auxiliar para indice da nova imagem
        for x=b1:b2
            d=1;% variavel auxiliar para indice da nova imagem
            for y=a1:a2
                img5(d,c)=img4(y,x);
                d=d+1;
            end
            c=c+1;
        end
    end
    img6=img5;
    aux=size(img5);
    if aux(1) > aux(2)
        img6=imrotate(img5,-90,'bilinear','loose');    
    end 
figure, imshow(img6)


%%% reconhecer codigo de barras %%%
%cbarras