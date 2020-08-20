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
Gz = c2d(Gs,Ta)
num = Gz.Num{1};
den = Gz.Den{1};


% definindo variaveis 
Kp = 0.0618;
Ki = 0.1882;
Kd = 0.0101;
Tau_d = 1/200;


discreto %PROGRAMA NO SIMULINK
TIME_SPAN = [0 TMAX]; %INTERVALO DE TEMPO
sim('discreto.mdl',TIME_SPAN) %PLAY DO SIMULINK                                                                              
