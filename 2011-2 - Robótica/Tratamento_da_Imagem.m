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

%Pegando o brilho m�dio da foto
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
% % % % %             img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=0;  %n�o recebe brilho
% % % % %         end              
        if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=media_brilho
            if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=(media_brilho+5)
                img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=255;  %recebe brilho
            else
                if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=media_brilho_foto
                    img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=255;  %recebe brilho
                else
                    img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=0;  %n�o recebe brilho
                end
            end
        else
            if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=(media_brilho-5)
                if img1(floor(tamanho_x/2+a),floor(tamanho_y/2+b))>=media_brilho_foto
                    img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=255;  %recebe brilho
                else
                    img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=0;  %n�o recebe brilho
                end                
            else
                img3(floor(tamanho_x/2+a),floor(tamanho_y/2+b))=0;  %n�o recebe brilho
            end
        end
        clear brilho
        %Pegando a pr�xima linha de trabalho
        b=b+1;
    end
    %Pegando a pr�xima coluna de trabalho
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
% % % % %             img3(a+1,b+1)=0;  %n�o recebe brilho
% % % % %         end
        if img1(a+1,b+1)>=media_brilho
            if img1(a+1,b+1)>=(media_brilho+5)
                img3(a+1,b+1)=255;  %recebe brilho
            else
                if img1(a+1,b+1)>=media_brilho_foto
                    img3(a+1,b+1)=255;  %recebe brilho
                else
                    img3(a+1,b+1)=0;  %n�o recebe brilho
                end
            end
        else
            if img1(a+1,b+1)>=(media_brilho-5)
                if img1(a+1,b+1)>=media_brilho_foto
                    img3(a+1,b+1)=255;  %recebe brilho
                else
                    img3(a+1,b+1)=0;  %n�o recebe brilho
                end                
            else
                img3(a+1,b+1)=0;  %n�o recebe brilho
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
% % % % %             img3(a,b+1)=0;  %n�o recebe brilho
% % % % %         end        
        if img1(a,b+1)>=media_brilho
            if img1(a,b+1)>=(media_brilho+5)
                img3(a,b+1)=255;  %recebe brilho
            else
                if img1(a,b+1)>=media_brilho_foto
                    img3(a,b+1)=255;  %recebe brilho
                else
                    img3(a,b+1)=0;  %n�o recebe brilho
                end
            end
        else
            if img1(a,b+1)>=(media_brilho-5)
                if img1(a,b+1)>=media_brilho_foto
                    img3(a,b+1)=255;  %recebe brilho
                else
                    img3(a,b+1)=0;  %n�o recebe brilho
                end                
            else
                img3(a,b+1)=0;  %n�o recebe brilho
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
% % % % %             img3(a+1,b)=0;  %n�o recebe brilho
% % % % %         end        
        if img1(a+1,b)>=media_brilho
            if img1(a+1,b)>=(media_brilho+5)
                img3(a+1,b)=255;  %recebe brilho
            else
                if img1(a+1,b)>=media_brilho_foto
                    img3(a+1,b)=255;  %recebe brilho
                else
                    img3(a+1,b)=0;  %n�o recebe brilho
                end
            end
        else
            if img1(a+1,b)>=(media_brilho-5)
                if img1(a+1,b)>=media_brilho_foto
                    img3(a+1,b)=255;  %recebe brilho
                else
                    img3(a+1,b)=0;  %n�o recebe brilho
                end                
            else
                img3(a+1,b)=0;  %n�o recebe brilho
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
% % % % %             img3(a,b)=0;  %n�o recebe brilho
% % % % %         end
        if img1(a,b)>=media_brilho
            if img1(a,b)>=(media_brilho+5)
                img3(a,b)=255;  %recebe brilho
            else
                if img1(a,b)>=media_brilho_foto
                    img3(a,b)=255;  %recebe brilho
                else
                    img3(a,b)=0;  %n�o recebe brilho
                end
            end
        else
            if img1(a,b)>=(media_brilho-5)
                if img1(a,b)>=media_brilho_foto
                    img3(a,b)=255;  %recebe brilho
                else
                    img3(a,b)=0;  %n�o recebe brilho
                end                
            else
                img3(a,b)=0;  %n�o recebe brilho
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
% % % % %             img3(ceil(a-tamanho_x/2+1),b+1)=0;  %n�o recebe brilho
% % % % %         end
        if img1(ceil(a-tamanho_x/2+1),b+1)>=media_brilho
            if img1(ceil(a-tamanho_x/2+1),b+1)>=(media_brilho+5)
                img3(ceil(a-tamanho_x/2+1),b+1)=255;  %recebe brilho
            else
                if img1(ceil(a-tamanho_x/2+1),b+1)>=media_brilho_foto
                    img3(ceil(a-tamanho_x/2+1),b+1)=255;  %recebe brilho
                else
                    img3(ceil(a-tamanho_x/2+1),b+1)=0;  %n�o recebe brilho
                end
            end
        else
            if img1(ceil(a-tamanho_x/2+1),b+1)>=(media_brilho-5)
                if img1(ceil(a-tamanho_x/2+1),b+1)>=media_brilho_foto
                    img3(ceil(a-tamanho_x/2+1),b+1)=255;  %recebe brilho
                else
                    img3(ceil(a-tamanho_x/2+1),b+1)=0;  %n�o recebe brilho
                end                
            else
                img3(ceil(a-tamanho_x/2+1),b+1)=0;  %n�o recebe brilho
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
% % % % %             img3(floor(a-tamanho_x/2+1),b)=0;  %n�o recebe brilho
% % % % %         end
        if img1(floor(a-tamanho_x/2+1),b)>=media_brilho
            if img1(floor(a-tamanho_x/2+1),b)>=(media_brilho+5)
                img3(floor(a-tamanho_x/2+1),b)=255;  %recebe brilho
            else
                if img1(floor(a-tamanho_x/2+1),b)>=media_brilho_foto
                    img3(floor(a-tamanho_x/2+1),b)=255;  %recebe brilho
                else
                    img3(floor(a-tamanho_x/2+1),b)=0;  %n�o recebe brilho
                end
            end
        else
            if img1(floor(a-tamanho_x/2+1),b)>=(media_brilho-5)
                if img1(floor(a-tamanho_x/2+1),b)>=media_brilho_foto
                    img3(floor(a-tamanho_x/2+1),b)=255;  %recebe brilho
                else
                    img3(floor(a-tamanho_x/2+1),b)=0;  %n�o recebe brilho
                end                
            else
                img3(floor(a-tamanho_x/2+1),b)=0;  %n�o recebe brilho
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
% % % % %             img3(a+1,ceil(b-tamanho_y/2+1))=0;  %n�o recebe brilho
% % % % %         end
        if img1(a+1,ceil(b-tamanho_y/2+1))>=media_brilho
            if img1(a+1,ceil(b-tamanho_y/2+1))>=(media_brilho+5)
                img3(a+1,ceil(b-tamanho_y/2+1))=255;  %recebe brilho
            else
                if img1(a+1,ceil(b-tamanho_y/2+1))>=media_brilho_foto
                    img3(a+1,ceil(b-tamanho_y/2+1))=255;  %recebe brilho
                else
                    img3(a+1,ceil(b-tamanho_y/2+1))=0;  %n�o recebe brilho
                end
            end
        else
            if img1(a+1,ceil(b-tamanho_y/2+1))>=(media_brilho-5)
                if img1(a+1,ceil(b-tamanho_y/2+1))>=media_brilho_foto
                    img3(a+1,ceil(b-tamanho_y/2+1))=255;  %recebe brilho
                else
                    img3(a+1,ceil(b-tamanho_y/2+1))=0;  %n�o recebe brilho
                end                
            else
                img3(a+1,ceil(b-tamanho_y/2+1))=0;  %n�o recebe brilho
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
% % % % %             img3(a,floor(b-tamanho_y/2+1))=0;  %n�o recebe brilho
% % % % %         end
        if img1(a,floor(b-tamanho_y/2+1))>=media_brilho
            if img1(a,floor(b-tamanho_y/2+1))>=(media_brilho+5)
                img3(a,floor(b-tamanho_y/2+1))=255;  %recebe brilho
            else
                if img1(a,floor(b-tamanho_y/2+1))>=media_brilho_foto
                    img3(a,floor(b-tamanho_y/2+1))=255;  %recebe brilho
                else
                    img3(a,floor(b-tamanho_y/2+1))=0;  %n�o recebe brilho
                end
            end
        else
            if img1(a,floor(b-tamanho_y/2+1))>=(media_brilho-5)
                if img1(a,floor(b-tamanho_y/2+1))>=media_brilho_foto
                    img3(a,floor(b-tamanho_y/2+1))=255;  %recebe brilho
                else
                    img3(a,floor(b-tamanho_y/2+1))=0;  %n�o recebe brilho
                end                
            else
                img3(a,floor(b-tamanho_y/2+1))=0;  %n�o recebe brilho
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
img4 = im2bw(img3,level);

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
imshow(img4)
title ('Threshold Local')