clear all;
clc;
%Analise da resposta em regime permanente
%Definindo Blocos
k3 = 12.8;
kb = 1.28;
B = 0.0078;
J = 3.79;
Ra = 2.4;
La = 1111111111.043;
%Definindo Bloco 1
Num1=[1];
Den1=[La Ra];
%Definindo Bloco 2
Num2=[k3];
Den2=[1];
%Definindo Bloco 3
Num3=[1];
Den3=[J B];
%Definindo Bloco 4
Num4=[kb];
Den4=[1];
%Calculando os Blocos 1,2 e 3 em serie = G(s)
[Num5,Den5]= series(Num1,Den1,Num2,Den2);
[NumG,DenG]= series(Num5,Den5,Num3,Den3);
%Calculando a F.T.M.F.
[Nummf,Denmf]= feedback(NumG,DenG,Num4,Den4,-1);
printsys(Nummf,Denmf,'s');
 
%Resposta gr�fica para uma entrada degrau unit�rio
%definindo base de tempo
t=1:50;
figure
step(Nummf,Denmf,t)
title('Resposta ao degrau unit�rio');
xlabel('tempo');
ylabel('sa�da');
grid

%Resposta gr�fica para uma entrada RAMPA
%Plotando para entrada rampa
u=t; 
figure
lsim(Nummf,Denmf,u,t)
title('Resposta a RAMPA');
xlabel('tempo');
ylabel('sa�da');
grid


%Analise da resposta transitoria
%Senso Wn: frequencia natural superamortecida, e E: Coeficiente de
%amortecimento
Wn = sqrt((B*Ra + k3*kb)/J*La);
E = (J*Ra + B*La)/(2*J*La*Wn)
fprintf('Como o valor de E(Coeficiente de amortecimento) � maior que 0 e menor que 1, entao o sistema � subamortecido')
N = [Wn^2];
D = [1 2*E*Wn Wn^2];
printsys(N,D,'s');
%Resposta gr�fica para uma entrada degrau unit�rio
%definindo base de tempo
t=1:1000;
figure
step(N,D,t)
title('Resposta ao degrau unit�rio');
xlabel('tempo');
ylabel('sa�da');
grid
%Plotando para entrada rampa
u=t; 
figure
lsim(N,D,u,t)
title('Resposta a RAMPA');
xlabel('tempo');
ylabel('sa�da');
grid