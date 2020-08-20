clc
close all
clear all

%Lendo imagens de um arquivo
foto=imread('testerotacao_d.JPG');

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
level = graythresh(img1);
img2 = im2bw(img1,level);

% % % % % %Mostra a figura binarizada globalmente
% % % % % figure
% % % % % imshow(img2)
% % % % % title ('Threshold Global')

%Calculo do threshold local
tamanho = size(img1);
porcentagem = input('Qual a porcentagem para o threshold local?\n');
tamanho_x = floor(tamanho(1)*porcentagem/100);  %tem q transformar em numeros inteiros
tamanho_y = floor(tamanho(2)*porcentagem/100); %tem q transformar em numeros inteiros
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

%Pegando o meio da figura
a=0;
while a~=floor((tamanho(1)*(100-porcentagem)/100+1))
    b=0;
    while  b~=floor((tamanho(2)*(100-porcentagem)/100)+1)
        i=1;                
        z=1;
        %pegando o brilho total do retangulo
        while (i+a)~=(tamanho_x+a)
            j=1;
            while (j+b)~=(tamanho_y+b)
                if (i+a)<= tamanho(1)
                    if (j+b) <= tamanho(2)
                        brilho(z)=img1(i+a,j+b);
                    end
                end                
                z=z+1;
                j=j+1;                
            end
            i=i+1;
        end           
        media_brilho=mean(brilho);
% % % % %         if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=media_brilho
% % % % %             img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=255;  %recebe brilho
% % % % %         else
% % % % %             img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=0;  %não recebe brilho
% % % % %         end              
        if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=media_brilho
            if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=(media_brilho+5)
                img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=255;  %recebe brilho
            else
                if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=media_brilho_foto
                    img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=255;  %recebe brilho
                else
                    img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=0;  %não recebe brilho
                end
            end
        else
            if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=(media_brilho-5)
                if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=media_brilho_foto
                    img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=255;  %recebe brilho
                else
                    img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=0;  %não recebe brilho
                end                
            else
                img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=0;  %não recebe brilho
            end
        end
        clear brilho
        %Pegando a próxima linha de trabalho
        b=b+1;
    end
    %Pegando a próxima coluna de trabalho
    a=a+1;
end

%Retangulo de cima da esquerda
a=0;
while a~=(ceil(tamanho_x/2))
    b=0;
    while b~=(ceil(tamanho_y/2))
        z=1;
        %pegando o brilho total do retangulo
        i=1;
        while i~=(ceil(tamanho_x/2+1+a))
            j=1;
            while j~=(ceil(tamanho_y/2+1+b))                
                brilho(z)=img1(i,j);       
                z=z+1;
                j=j+1;
            end
            i=i+1;
        end        
        media_brilho=mean(brilho);
% % % % %         if img1(a+1,b+1)>=media_brilho
% % % % %             img3(a+1,b+1)=255;  %recebe brilho
% % % % %         else
% % % % %             img3(a+1,b+1)=0;  %não recebe brilho
% % % % %         end
        if img1(a+1,b+1)>=media_brilho
            if img1(a+1,b+1)>=(media_brilho+5)
                img3(a+1,b+1)=255;  %recebe brilho
            else
                if img1(a+1,b+1)>=media_brilho_foto
                    img3(a+1,b+1)=255;  %recebe brilho
                else
                    img3(a+1,b+1)=0;  %não recebe brilho
                end
            end
        else
            if img1(a+1,b+1)>=(media_brilho-5)
                if img1(a+1,b+1)>=media_brilho_foto
                    img3(a+1,b+1)=255;  %recebe brilho
                else
                    img3(a+1,b+1)=0;  %não recebe brilho
                end                
            else
                img3(a+1,b+1)=0;  %não recebe brilho
            end
        end
        clear brilho
        b=b+1;
    end
    a=a+1;
end

%Retangulo de cima da direita
a=tamanho(1);
while a~=(floor(tamanho(1)-tamanho_x/2-1))
    b=0;
    while b~=(ceil(tamanho_y/2))
        z=1;
        %pegando o brilho total do retangulo
        i=floor(tamanho_x/2);
        while (a-i)~=tamanho(1)+1
            j=1;
            while j~=(ceil(tamanho_y/2+1+b))
                brilho(z)=img1(a-i,j);       
                z=z+1;
                j=j+1;
            end
            i=i-1;
        end        
        media_brilho=mean(brilho);
% % % % %         if img1(a,b+1)>=media_brilho
% % % % %             img3(a,b+1)=255;  %recebe brilho
% % % % %         else
% % % % %             img3(a,b+1)=0;  %não recebe brilho
% % % % %         end        
        if img1(a,b+1)>=media_brilho
            if img1(a,b+1)>=(media_brilho+5)
                img3(a,b+1)=255;  %recebe brilho
            else
                if img1(a,b+1)>=media_brilho_foto
                    img3(a,b+1)=255;  %recebe brilho
                else
                    img3(a,b+1)=0;  %não recebe brilho
                end
            end
        else
            if img1(a,b+1)>=(media_brilho-5)
                if img1(a,b+1)>=media_brilho_foto
                    img3(a,b+1)=255;  %recebe brilho
                else
                    img3(a,b+1)=0;  %não recebe brilho
                end                
            else
                img3(a,b+1)=0;  %não recebe brilho
            end
        end
        clear brilho
        b=b+1;
    end
    a=a-1;
end

%Retangulo de baixo da esquerda 
a=0;
while a~=(ceil(tamanho_x/2))
    b=tamanho(2);
    while b~=(floor(tamanho(2)-tamanho_y/2-1))
        z=1;
        %pegando o brilho total do retangulo
        i=1;
        while i~=(ceil(tamanho_x/2+1+a))
            j=floor(tamanho_y/2);
            while (b-j)~=tamanho(2)+1                
                brilho(z)=img1(i,b-j);       
                z=z+1;
                j=j-1;
            end
            i=i+1;
        end        
        media_brilho=mean(brilho);
% % % % %         if img1(a+1,b)>=media_brilho
% % % % %             img3(a+1,b)=255;  %recebe brilho
% % % % %         else
% % % % %             img3(a+1,b)=0;  %não recebe brilho
% % % % %         end        
        if img1(a+1,b)>=media_brilho
            if img1(a+1,b)>=(media_brilho+5)
                img3(a+1,b)=255;  %recebe brilho
            else
                if img1(a+1,b)>=media_brilho_foto
                    img3(a+1,b)=255;  %recebe brilho
                else
                    img3(a+1,b)=0;  %não recebe brilho
                end
            end
        else
            if img1(a+1,b)>=(media_brilho-5)
                if img1(a+1,b)>=media_brilho_foto
                    img3(a+1,b)=255;  %recebe brilho
                else
                    img3(a+1,b)=0;  %não recebe brilho
                end                
            else
                img3(a+1,b)=0;  %não recebe brilho
            end
        end
        clear brilho
        b=b-1;
    end
    a=a+1;
end

%Retangulo de baixo da direita
a=tamanho(1);
while a~=(floor(tamanho(1)-tamanho_x/2-1))
    b=tamanho(2);
    while b~=(floor(tamanho(2)-tamanho_y/2-1))
        z=1;
        %pegando o brilho total do retangulo
        i=floor(tamanho_x/2);
        while (a-i)~=tamanho(1)+1
            j=floor(tamanho_y/2);
            while (b-j)~=tamanho(2)+1                
                brilho(z)=img1(a-i,b-j);       
                z=z+1;
                j=j-1;
            end
            i=i-1;
        end        
        media_brilho=mean(brilho);
% % % % %         if img1(a,b)>=media_brilho
% % % % %             img3(a,b)=255;  %recebe brilho
% % % % %         else
% % % % %             img3(a,b)=0;  %não recebe brilho
% % % % %         end
        if img1(a,b)>=media_brilho
            if img1(a,b)>=(media_brilho+5)
                img3(a,b)=255;  %recebe brilho
            else
                if img1(a,b)>=media_brilho_foto
                    img3(a,b)=255;  %recebe brilho
                else
                    img3(a,b)=0;  %não recebe brilho
                end
            end
        else
            if img1(a,b)>=(media_brilho-5)
                if img1(a,b)>=media_brilho_foto
                    img3(a,b)=255;  %recebe brilho
                else
                    img3(a,b)=0;  %não recebe brilho
                end                
            else
                img3(a,b)=0;  %não recebe brilho
            end
        end        
        clear brilho
        b=b-1;
    end
    a=a-1;
end

%Borda de cima
a=tamanho_x;
while a~=(tamanho(1))
    b=0;
    while b~=(floor(tamanho_y/2))
        z=1;
        %pegando o brilho total do retangulo
        i=0;
        while i~=(tamanho_x)
            j=1;
            while j~=(floor(tamanho_y/2+1+b))
                brilho(z)=img1(a-i,j);       
                z=z+1;
                j=j+1;
            end
            i=i+1;
        end
        media_brilho=mean(brilho);        
% % % % %         if img1(ceil(a-tamanho_x/2+1),b+1)>=media_brilho
% % % % %             img3(ceil(a-tamanho_x/2+1),b+1)=255;  %recebe brilho
% % % % %         else
% % % % %             img3(ceil(a-tamanho_x/2+1),b+1)=0;  %não recebe brilho
% % % % %         end
        if img1(ceil(a-tamanho_x/2+1),b+1)>=media_brilho
            if img1(ceil(a-tamanho_x/2+1),b+1)>=(media_brilho+5)
                img3(ceil(a-tamanho_x/2+1),b+1)=255;  %recebe brilho
            else
                if img1(ceil(a-tamanho_x/2+1),b+1)>=media_brilho_foto
                    img3(ceil(a-tamanho_x/2+1),b+1)=255;  %recebe brilho
                else
                    img3(ceil(a-tamanho_x/2+1),b+1)=0;  %não recebe brilho
                end
            end
        else
            if img1(ceil(a-tamanho_x/2+1),b+1)>=(media_brilho-5)
                if img1(ceil(a-tamanho_x/2+1),b+1)>=media_brilho_foto
                    img3(ceil(a-tamanho_x/2+1),b+1)=255;  %recebe brilho
                else
                    img3(ceil(a-tamanho_x/2+1),b+1)=0;  %não recebe brilho
                end                
            else
                img3(ceil(a-tamanho_x/2+1),b+1)=0;  %não recebe brilho
            end
        end               
        clear brilho
        b=b+1;
    end
    a=a+1;
end

%Borda de baixo
a=tamanho_x;
while a~=(tamanho(1))
    b=tamanho(2);
    while b~=(floor(tamanho(2)-tamanho_y/2-1))
        z=1;
        %pegando o brilho total do retangulo
        i=0;
        while i~=(tamanho_x)
            j=floor(tamanho_y/2);
            while (b-j)~=tamanho(2)+1                  
                brilho(z)=img1(a-i,b-j);       
                z=z+1;
                j=j-1;
            end
            i=i+1;
        end
        media_brilho=mean(brilho);        
% % % % %         if img1(floor(a-tamanho_x/2+1),b)>=media_brilho
% % % % %             img3(floor(a-tamanho_x/2+1),b)=255;  %recebe brilho
% % % % %         else
% % % % %             img3(floor(a-tamanho_x/2+1),b)=0;  %não recebe brilho
% % % % %         end
        if img1(floor(a-tamanho_x/2+1),b)>=media_brilho
            if img1(floor(a-tamanho_x/2+1),b)>=(media_brilho+5)
                img3(floor(a-tamanho_x/2+1),b)=255;  %recebe brilho
            else
                if img1(floor(a-tamanho_x/2+1),b)>=media_brilho_foto
                    img3(floor(a-tamanho_x/2+1),b)=255;  %recebe brilho
                else
                    img3(floor(a-tamanho_x/2+1),b)=0;  %não recebe brilho
                end
            end
        else
            if img1(floor(a-tamanho_x/2+1),b)>=(media_brilho-5)
                if img1(floor(a-tamanho_x/2+1),b)>=media_brilho_foto
                    img3(floor(a-tamanho_x/2+1),b)=255;  %recebe brilho
                else
                    img3(floor(a-tamanho_x/2+1),b)=0;  %não recebe brilho
                end                
            else
                img3(floor(a-tamanho_x/2+1),b)=0;  %não recebe brilho
            end
        end                
        clear brilho
        b=b-1;
    end
    a=a+1;
end

%Borda da esquerda
a=0;
while a~=(floor(tamanho_x/2))
    b=tamanho_y;
    while b~=(tamanho(2))
        z=1;
        %pegando o brilho total do retangulo
        i=1;
        while i~=(floor(tamanho_x/2+1+a))
            j=0;
            while j~=(tamanho_y)                
                brilho(z)=img1(i,b-j);       
                z=z+1;
                j=j+1;
            end
            i=i+1;
        end        
        media_brilho=mean(brilho);
% % % % %         if img1(a+1,ceil(b-tamanho_y/2+1))>=media_brilho
% % % % %             img3(a+1,ceil(b-tamanho_y/2+1))=255;  %recebe brilho
% % % % %         else
% % % % %             img3(a+1,ceil(b-tamanho_y/2+1))=0;  %não recebe brilho
% % % % %         end
        if img1(a+1,ceil(b-tamanho_y/2+1))>=media_brilho
            if img1(a+1,ceil(b-tamanho_y/2+1))>=(media_brilho+5)
                img3(a+1,ceil(b-tamanho_y/2+1))=255;  %recebe brilho
            else
                if img1(a+1,ceil(b-tamanho_y/2+1))>=media_brilho_foto
                    img3(a+1,ceil(b-tamanho_y/2+1))=255;  %recebe brilho
                else
                    img3(a+1,ceil(b-tamanho_y/2+1))=0;  %não recebe brilho
                end
            end
        else
            if img1(a+1,ceil(b-tamanho_y/2+1))>=(media_brilho-5)
                if img1(a+1,ceil(b-tamanho_y/2+1))>=media_brilho_foto
                    img3(a+1,ceil(b-tamanho_y/2+1))=255;  %recebe brilho
                else
                    img3(a+1,ceil(b-tamanho_y/2+1))=0;  %não recebe brilho
                end                
            else
                img3(a+1,ceil(b-tamanho_y/2+1))=0;  %não recebe brilho
            end
        end             
        clear brilho
        b=b+1;
    end
    a=a+1;
end

%Borda da direita
a=tamanho(1);
while a~=(floor(tamanho(1)-tamanho_x/2-1))
    b=tamanho_y;
    while b~=(tamanho(2))
        z=1;
        %pegando o brilho total do retangulo
         i=floor(tamanho_x/2);
        while (a-i)~=tamanho(1)+1
            j=0;
            while j~=(tamanho_y)                
                brilho(z)=img1(a-i,b-j);       
                z=z+1;
                j=j+1;
            end
            i=i-1;
        end        
        media_brilho=mean(brilho);
% % % % %         if img1(a,floor(b-tamanho_y/2+1))>=media_brilho
% % % % %             img3(a,floor(b-tamanho_y/2+1))=255;  %recebe brilho
% % % % %         else
% % % % %             img3(a,floor(b-tamanho_y/2+1))=0;  %não recebe brilho
% % % % %         end
        if img1(a,floor(b-tamanho_y/2+1))>=media_brilho
            if img1(a,floor(b-tamanho_y/2+1))>=(media_brilho+5)
                img3(a,floor(b-tamanho_y/2+1))=255;  %recebe brilho
            else
                if img1(a,floor(b-tamanho_y/2+1))>=media_brilho_foto
                    img3(a,floor(b-tamanho_y/2+1))=255;  %recebe brilho
                else
                    img3(a,floor(b-tamanho_y/2+1))=0;  %não recebe brilho
                end
            end
        else
            if img1(a,floor(b-tamanho_y/2+1))>=(media_brilho-5)
                if img1(a,floor(b-tamanho_y/2+1))>=media_brilho_foto
                    img3(a,floor(b-tamanho_y/2+1))=255;  %recebe brilho
                else
                    img3(a,floor(b-tamanho_y/2+1))=0;  %não recebe brilho
                end                
            else
                img3(a,floor(b-tamanho_y/2+1))=0;  %não recebe brilho
            end
        end                 
        clear brilho
        b=b+1;
    end
    a=a-1;
end

% % % % % %Mostra a figura binarizada localmente
% % % % % figure
% % % % % imshow(img3)
% % % % % title ('Threshold Local sem binearilizar')

level = graythresh(img3);
img3 = im2bw(img3,level);

% % % % % figure
% % % % % imshow(img4)
% % % % % title ('Threshold Local')

%mostra todas as imagens trabalhadas
subplot(2,2,1)
imshow(foto)
title ('Foto original')
subplot(2,2,2)
imshow(img2)
title ('Threshold Global')
subplot(2,2,3)
imshow(img3)
title ('Threshold Local')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% reconhecer codigo de barras %%%
clc
clear img codigo largura palavra lido
img=img6;

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