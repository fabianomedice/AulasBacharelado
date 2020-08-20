clc
clear all
close all
TMAX = 10;
Ta = 1/1000; %tempo de amostragem
A = 30; %amplitude do degrau
%SATURAÇAO
UPPER_SAT = 5;
LOWER_SAT = -5;
%BANDA MORTA
START_DEAD_ZONE = -2.3;
END_DEAD_ZONE = 2.3;
%RUIDO ALEATORIO
MEDIA_RUIDO = 0;
VARIANCIA_RUIDO = 0.05;
%tempo morto
teta = 0;
%planta G(S)
G1 = tf(20,[1 0]);
G2 = tf(1,[1/10 1]);
G3 = tf(1,[1/2000 1]);
Gs = G1*G2*G3
num = Gs.Num{1};
den = Gs.Den{1};


% definindo variaveis 

Kp = 0.5614;
Ki = 1.7097;
Kd = 0.0922;
Tau_d = -1/(-200);


untitled %PROGRAMA NO SIMULINK
TIME_SPAN = [0 TMAX]; %INTERVALO DE TEMPO
sim('untitled.mdl',TIME_SPAN) %PLAY DO SIMULINK                                                                              
