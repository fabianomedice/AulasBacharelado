clc
clear all
close all

%entrada da planta

N = 30; %numero de pontos (contando com o 0)
x = 0:6/(N-1):6; %intervalo de 0 a 6 volts com o numero de pontos escolhido

Ta = 0.1; %tempo de amostragem
Td = 100; %o multiplo do tempo de amostragem (assim obtendo o tempo do degrau)

%montando o degrau

i = 1;
k = 1;

while i ~= N*Td+1
      
    j = 1;
    
    while j ~= Td+1
        
        MV(i) = x(k);
        i = i+1;
        j = j+1;
        
    end
    
    k = k+1;
    
end

Tempo = 0:Ta:N*Ta*Td; 

i = 1;

%para retirar o ultimo termo do vetor tempo e os vetores de entrada e tempo 
%ficarem com o mesmo tamanho

while i ~= N*Td+1
    
    Ts(i)=Tempo(i);%tempo de simulação para mandar para planta
    
    i = i+1;
    
end

stem (Ts,MV) %mostra os impulsos

%colocando os dados no site

data = [Ts; MV]'; %salvando os arquivos
save data data -V6 %salvando o arquivo em formato .mat

keyboard %parar o programa para esperar os dados do site voltar

%achar banda morta e saturaçao
%achando os ultimos valores de MV para olhar o tempo e depois pegar o Y
%neste tempo

figure
plot (rt_Time,rt_Output,rt_Time,10*rt_Command,'r');

Banda_Morta = 3.31; %ultimo degrau antes de responder, o proximo foi 3.517
Saturacao = 6;

%gerar o sinal aleatorio binario com um pouco a mais da maxima banda morta e um pouco menos do minimo da
%saturaçao para usar como max e min do intervalo

sinal_aleatorio = rand(1,N*Td);

i = 1;
while i ~= N*Td+1
    
    if sinal_aleatorio (i) >= 0.5
        
        sinal_aleatorio_binario(i) = 0.9 * Saturacao;
        
    else
        
        sinal_aleatorio_binario(i) = 1.1 * Banda_Morta;
        
    end
    
    i = i+1;
    
end

%colocando os dados no site

data = [Ts; sinal_aleatorio_binario]'; %salvando os arquivos
save data data -V6 %salvando o arquivo em formato .mat

keyboard %parar o programa para esperar os dados do site voltar

atrasos = -(N-1):1:(N-1);

%para achar os atrasos de x em relaçao ao y

figure
crosscorr (rt_Command,rt_Output) %comparar entrada e saida para ver quais os termos dependentes
grid on

%para achar os atrasos de y em relaçao ao proprio y

figure
crosscorr (rt_Output,rt_Output); %comparar saida e saida para ver quais os termos dependentes
grid on

keyboard %parar o programa para esperar que a equação a diferenças seja feita

%tirando os Minimos Quadrados

%montar a equação a diferenças da planta Y = A x Teta
%y[k] = x[k-2] + x[k-3] + x[k-4] + x[k-5] + x[k-6] + x[k-7] + x[k-8] + x[k-9] + x[k-10] +
%x[k-11] + x[k-12] + x[k-13] + x[k-14] + x[k-15] + x[k-16] + y[k-1] + y[k-2] +
%y[k-3] + y[k-4] + y[k-5] + y[k-6] + y[k-7] + y[k-8] + y[k-9] + y[k-10] +
%y[k-11] + y[k-12] + y[k-13] + y[k-14] + y[k-15] + y[k-16] + y[k-17] + constante

A1 = [rt_Command(16:N-2) rt_Command(15:N-3) rt_Command(14:N-4) rt_Command(13:N-5) rt_Command(12:N-6) rt_Command(11:N-7) rt_Command(10:N-8) rt_Command(9:N-9) rt_Command(8:N-10) rt_Command(7:N-11) rt_Command(6:N-12) rt_Command(5:N-13) rt_Command(4:N-14) rt_Command(3:N-15) rt_Command(2:N-16) rt_Output(17:N-1) rt_Output(16:N-2) rt_Output(15:N-3) rt_Output(14:N-4) rt_Output(13:N-5) rt_Output(12:N-6) rt_Output(11:N-7) rt_Output(10:N-8) rt_Output(9:N-9) rt_Output(8:N-10) rt_Output(7:N-11) rt_Output(6:N-12) rt_Output(5:N-13) rt_Output(4:N-14) rt_Output(3:N-15) rt_Output(2:N-16) rt_Output(1:N-17) ones(N-17,1)];
Y = rt_Output(18:N);
Teta1 = A1\Y

Yc1 = A1*Teta1; % saida calculada pelo modelo
Residuo1 = Y - Yc1;
k1 = length(Teta1); %numero de parametros do modelo
AIC1 = N*log(sum(Residuo1.^2)) + 2*k1 %akaike information criterion

keyboard %parar o programa para esperar que a 2 equação a diferenças seja feita

%montar a equação a diferenças da planta Y = A x Teta somente com os termos
%que fazem diferença para ficar mais preciso
%y[k] = x[k-3] + x[k-4] + x[k-6] + y[k-1] + y[k-3] + y[k-8] + y[k-11] + y[k-12] + y[k-13] + y[k-14] + y[k-15] + y[k-16] + y[k-17] 

A2 = [rt_Command(15:N-3) rt_Command(14:N-4) rt_Command(12:N-6) rt_Output(17:N-1) rt_Output(15:N-3) rt_Output(10:N-8) rt_Output(7:N-11) rt_Output(6:N-12) rt_Output(5:N-13) rt_Output(4:N-14) rt_Output(3:N-15) rt_Output(2:N-16) rt_Output(1:N-17)];
Teta2 = A2\Y

Yc2 = A2*Teta2; % saida calculada pelo modelo
Residuo2 = Y - Yc2;
k2 = length(Teta2); %numero de parametros do modelo
AIC2 = N*log(sum(Residuo2.^2)) + 2*k2 %akaike information criterion

keyboard %parar o programa para esperar que a 3 equação a diferenças seja feita

%montar a equação a diferenças da planta Y = A x Teta somente com os termos
%que fazem diferença para ficar mais preciso
%y[k] = x[k-3] + x[k-4] + x[k-6] + y[k-1] + y[k-8] y[k-11] + y[k-14] + y[k-15] + y[k-16]  

A3 = [rt_Command(15:N-3) rt_Command(14:N-4) rt_Command(12:N-6) rt_Output(17:N-1) rt_Output(10:N-8) rt_Output(7:N-11) rt_Output(4:N-14) rt_Output(3:N-15) rt_Output(2:N-16)];
Teta3 = A3\Y

Yc3 = A3*Teta3; % saida calculada pelo modelo
Residuo3 = Y - Yc3;
k3 = length(Teta3); %numero de parametros do modelo
AIC3 = N*log(sum(Residuo3.^2)) + 2*k3 %akaike information criterion

keyboard %parar o programa para esperar que a 4 equação a diferenças seja feita

%montar a equação a diferenças da planta Y = A x Teta somente com os termos
%que fazem diferença para ficar mais preciso de acordo com o professor
%y[k] = x[k-2] + x[k-3] + x[k-4] + x[k-6] + y[k-1] + y[k-3] + constante

A4 = [rt_Command(16:N-2) rt_Command(15:N-3) rt_Command(14:N-4) rt_Command(12:N-6) rt_Output(17:N-1) rt_Output(15:N-3) ones(N-17,1)];
Teta4 = A4\Y

Yc4 = A4*Teta4; % saida calculada pelo modelo
Residuo4 = Y - Yc4;
k4 = length(Teta4); %numero de parametros do modelo
AIC4 = N*log(sum(Residuo4.^2)) + 2*k4 %akaike information criterion

keyboard %parar o programa para esperar que a 5 equação a diferenças seja feita

%montar a equação a diferenças da planta Y = A x Teta somente com os termos
%que fazem diferença para ficar mais preciso de acordo com o professor
%y[k] = x[k-2] + x[k-3] + x[k-4] + y[k-1] + y[k-3] + constante

A5 = [rt_Command(16:N-2) rt_Command(15:N-3) rt_Command(14:N-4) rt_Output(17:N-1) rt_Output(15:N-3) ones(N-17,1)];
Teta5 = A5\Y

Yc5 = A5*Teta5; % saida calculada pelo modelo
Residuo5 = Y - Yc5;
k5 = length(Teta5); %numero de parametros do modelo
AIC5 = N*log(sum(Residuo5.^2)) + 2*k5 %akaike information criterion

keyboard %parar o programa para esperar que a 6 equação a diferenças seja feita

%montar a equação a diferenças da planta Y = A x Teta somente com os termos
%que fazem diferença para ficar mais preciso de acordo com o professor
%y[k] = x[k-2] + x[k-3] + x[k-4] + y[k-1] + y[k-3]

A6 = [rt_Command(16:N-2) rt_Command(15:N-3) rt_Command(14:N-4) rt_Output(17:N-1) rt_Output(15:N-3)];
Teta6 = A6\Y

Yc6 = A6*Teta6; % saida calculada pelo modelo
Residuo6 = Y - Yc6;
k6 = length(Teta6); %numero de parametros do modelo
AIC6 = N*log(sum(Residuo6.^2)) + 2*k6 %akaike information criterion

keyboard %parar o programa para esperar que a 7 equação a diferenças seja feita

%montar a equação a diferenças da planta Y = A x Teta somente com os termos
%que fazem diferença para ficar mais preciso de acordo com o professor
%y[k] = x[k-2] + x[k-3] + y[k-1] + y[k-3]

A7 = [rt_Command(16:N-2) rt_Command(15:N-3) rt_Output(17:N-1) rt_Output(15:N-3)];
Teta7 = A7\Y

Yc7 = A7*Teta7; % saida calculada pelo modelo
Residuo7 = Y - Yc7;
k7 = length(Teta7); %numero de parametros do modelo
AIC7 = N*log(sum(Residuo7.^2)) + 2*k7 %akaike information criterion

keyboard %parar o programa para esperar que a 8 equação a diferenças seja feita

%montar a equação a diferenças da planta Y = A x Teta somente com os termos
%que fazem diferença para ficar mais preciso de acordo com o professor
%y[k] = x[k] + x[k-1] + x[k-2] + x[k-3] + x[k-4] + x[k-5] + x[k-6] + y[k-1]+ y[k-2] + y[k-3] + y[k-4] + y[k-5] + y[k-6]

A8 = [rt_Command(18:N) rt_Command(17:N-1) rt_Command(16:N-2) rt_Command(15:N-3) rt_Command(14:N-4) rt_Command(13:N-5) rt_Command(12:N-6) rt_Output(17:N-1) rt_Output(16:N-2) rt_Output(15:N-3) rt_Output(14:N-4) rt_Output(13:N-5) rt_Output(12:N-6)];
Teta8 = A8\Y

Yc8 = A8*Teta8; % saida calculada pelo modelo
Residuo8 = Y - Yc8;
k8 = length(Teta8); %numero de parametros do modelo
AIC8 = N*log(sum(Residuo8.^2)) + 2*k8 %akaike information criterion

% como pedido pelo professor, utilizaremos a equação 8 
% y[k] = x[k] + x[k-1] + x[k-2] + x[k-3] + x[k-4] + x[k-5] + x[k-6] + y[k-1]+ y[k-2] + y[k-3] + y[k-4] + y[k-5] + y[k-6]
% y[k+6] = x[k+6] + x[k+5] + x[k+4] + x[k+3] + x[k+2] + x[k+1] + x[k] + y[k+5]+ y[k+4] + y[k+3] + y[k+2] + y[k+1] + y[k]
% z^6 y(z) = z^6 x(z) + z^5 x(z) + z^4 x(z) + z^3 x(z) + z^2 x(z) + z x(z) + x(z) + z^5 y(z) + z^4 y(z) + z^3 y(z) + z^2 y(z) + z y(z) + y(z)
% z^6 y(z)- z^5 y(z) - z^4 y(z) - z^3 y(z) - z^2 y(z) - z y(z) - y(z) = z^6 x(z) + z^5 x(z) + z^4 x(z) + z^3 x(z) + z^2 x(z) + z x(z) + x(z) 
% (z^6 - z^5 - z^4 - z^3 - z^2 - z - 1) y(z) = (z^6 + z^5 + z^4 + z^3 + z^2 + z + 1) x(z)
% y(z)/x(z) = (z^6 + z^5 + z^4 + z^3 + z^2 + z + 1) / (z^6 - z^5 - z^4 - z^3 - z^2 - z - 1)
% y(z)/x(z) = (0.0154 z^6 -0.1308 z^5 -0.3082 z^4 +1.1892 z^3 + 1.6618 z^2 +1.5483 z + 0.2994) / (z^6 -0.1106 z^5 -0.2860 z^4 -0.4816 z^3 +0.5898 z^2 - 0.3666 z +0.2016)


%como o A2 possui o menor AIC, usaremos seus parametros

%A planta é:
% y[k] = x[k-3] + x[k-4] + x[k-6] + y[k-1] + y[k-3] + y[k-8] + y[k-11] + y[k-12] + y[k-13] + y[k-14] + y[k-15] + y[k-16] + y[k-17] 
% y[k] - y[k-1] - y[k-3] - y[k-8] - y[k-11] - y[k-12] - y[k-13] - y[k-14] - y[k-15] - y[k-16] - y[k-17] = x[k-3] + x[k-4] + x[k-6] 
% y[k+17] - y[k+16] - y[k+14] - y[k+9] - y[k+6] - y[+5] - y[k+4] - y[k+3] - y[k+2] - y[k+1] - y[k] = x[k+14] + x[k+13] + x[k+11] 
% z^17 y(z) - z^16 y(z) - z^14 y(z) - z^9 y(z) - z^6 y(z) - z^5 y(z) -z^4 y(z) - z^3 y(z) - z^2 y(z) - z y(z) - y(z) = z^14 x(z) + z^13 x(z) + z^11 x(z)
% y(z) (z^17 -z^16 -z^14 -z^9 -z^6 -z^5 -z^4 -z^3 -z^2 -z -1) = x(z) (z^14 + z^13 + z^11)
% y(z)/x(z) = (z^14 + z^13 + z^11)/(z^17 -z^16 -z^14 -z^9 -z^6 -z^5 -z^4 -z^3 -z^2 -z -1)
% y(z)/x(z) = ( 0.5441 z^14 +0.4959 z^13 -0.3858 z^11)/(z^17 -0.9654 z^16 -0.0810 z^14 +0.2549 z^9 -0.1930 z^6 -0.0543 z^5 +0.0565 z^4 +0.1138 z^3 -0.1976 z^2 +0.2538z -0.0892)