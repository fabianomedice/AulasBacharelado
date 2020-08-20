clc
clear all
close all

%parâmetros do trabalho

teta = 2.34;
k = 0.66;
tal = 4.39;

%função de transferência

num1 = [0 k];
den1 = [tal 1];
printsys(num1,den1)

%tempo morto
num2 = [-1 2/teta];
den2 = [1 2/teta];
printsys(num2,den2)
% [n,d]=pade(teta,1)
% printsys(n,d)

%P(s)
%Zero = 0.8547
%Pólo 1 = -0.8547 ; Pólo 2 = -0.2278

[num,den] = series(num1,den1,num2,den2);
printsys(num,den)

%Lugar das raizes da planta

% figure
% rlocus(num,den); 
% hold on
% sgrid

%Escolhendo os 2 Zeros

Z1=-0.2277;
Z2=-1;
numz = [1 -(Z1+Z2) Z1*Z2];
denz = [0 1 0];
printsys(numz,denz)

%Função de transferencia controlada

[numtf,dentf] = series (num,den,numz,denz);
printsys(numtf,dentf)
figure
rlocus(numtf,dentf);

%Pegando o ganho K para achar os melhores Ki, Kd, Kp

 keyboard
 k = rlocfind(numtf,dentf);

% Achando os Valores de Ki, Kd, Kp
%Kd = K
%Kp/Kd = -(Z1+Z2)
%Ki/Kd = Z1*Z2

kd = k
kp = -(Z1+Z2)*kd
ki = Z1*Z2*kd

%Controlador PID ideal
% 1 polo em 0
% 2 zeros compostos em {[-kp + (kp^2 - 4*kd*ki)^(1/2)]/[2*kd]} e 
%{[-kp - (kp^2 - 4*kd*ki)^(1/2)]/[2*kd]}

numc = [kd kp ki];
denc = [0 1 0];
printsys(numc,denc)

%Função de transferencia controlada

[numtf,dentf] = series (num,den,numc,denc);
printsys(numtf,dentf)


%Entrada degrau unitário
[nMF,dMF] = feedback(numtf,dentf,1,1);

Ta = 1/1000;
t = 0:Ta:60; %vetor tempo
y = step(nMF,dMF,t);
figure
plot(t,y)
grid on