clc;
clear all;
close all;

%adicionando os valores para a função de tranferencia
Wn = 5; %Wn do sistema
E = 0.1; %epsilon do sistema
Num = [Wn*Wn];
Den = [1 2*E*Wn Wn*Wn];
printsys (Num,Den) %mostrar a função de tranferencia
t = linspace (0,20,1000); %vetor tempo
y=step(Num,Den,t);
figure
plot(t,y)
grid on
Ultrapassagem_Percentual = UP(y)
Tempo_de_Acomodacao = Ts(t,y)
Tempo_de_Pico = Tp(t,y)
Erro_em_estado_estacionario = ees(y,1)
ITAE = itae(t,y,1)
Epsilon = epsilon(Ultrapassagem_Percentual)
Frequencia_Natural_Wn = freqnat(Tempo_de_Acomodacao,Epsilon)