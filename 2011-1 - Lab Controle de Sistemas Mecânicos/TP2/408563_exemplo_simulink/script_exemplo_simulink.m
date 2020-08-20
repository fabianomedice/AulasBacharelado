clc
clear all
close all

%% Parâmetros de configuração da simulação
Tmax = 15; % tempo total da simulação (altere de acordo com seu tempo de acomodação) 
A = 1; % valor do degrau

%% Parâmetros da PLANTA (insira aqui os parâmetros de sua planta)
teta = 1; % tempo morto
K = 2; % ganho da planta em malha aberta
Tau = 4; % constante de tempo da planta em malha aberta

%% Parâmetros do PID (sintonize seu controlador)
Kp = 1;
Ki = 0;
Kd = 0;

%% Invoca o objeto simulink
PID_IDEAL_Kp_Ki_Kd_r2009a



