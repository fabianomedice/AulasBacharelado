clc
clear all
close all

%% Par�metros de configura��o da simula��o
Tmax = 15; % tempo total da simula��o (altere de acordo com seu tempo de acomoda��o) 
A = 1; % valor do degrau

%% Par�metros da PLANTA (insira aqui os par�metros de sua planta)
teta = 1; % tempo morto
K = 2; % ganho da planta em malha aberta
Tau = 4; % constante de tempo da planta em malha aberta

%% Par�metros do PID (sintonize seu controlador)
Kp = 1;
Ki = 0;
Kd = 0;

%% Invoca o objeto simulink
PID_IDEAL_Kp_Ki_Kd_r2009a



