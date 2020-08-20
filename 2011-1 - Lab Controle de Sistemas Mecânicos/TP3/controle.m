clc
close all

Ta = 10/1000; %tempo de amostragem

%A planta

% y(z)/x(z) = ( 0.5441 z^14 +0.4959 z^13 -0.3858 z^11)/(z^17 -0.9654 z^16 -0.0810 z^14 +0.2549 z^9 -0.1930 z^6 -0.0543 z^5 +0.0565 z^4 +0.1138 z^3 -0.1976 z^2 +0.2538z -0.0892)

nump = [0 0 0 0.5441 0.4959 0 -0.3858 0 0 0 0 0 0 0 0 0 0 0];
denp = [1 -0.9654 0 -0.0810 0 0 0 0 0.2549 0 0 -0.1930 -0.0543 0.0565 0.1138 -0.1976 0.2538 -0.0892];

Gz = tf (nump,denp,Ta)
figure
rlocus (Gz)
zgrid
zeros_Gz = zero(Gz)
polos_Gz = pole(Gz)
% 
% keyboard
% 
% %Os ganhos Kp, Ki, Kd
% 
% K_P = rlocfind (Gz); %ganho do controlador P
% 
% %Para o controlador P
% %Kp = K
% 
% Kp_P = K_P
% Ki_P = 0;
% Kd_P = 0;
% 
% %Controlador PD
% %1 Zero = 1 / (Kp/Kd * Ta + 1)
% %1 Polo = 0
% 
% Zero_PD = 0.57;
% 
% num_PD = [1 -Zero_PD];
% den_PD = [Ta 0];
% 
% [nump_PD,denp_PD] = series(nump,denp,num_PD,den_PD);
% G_PD = tf (nump_PD,denp_PD,Ta);
% figure
% rlocus (G_PD)
% zgrid
% 
% keyboard
% 
% K_PD = rlocfind (G_PD); %ganho do controlador PD
% 
% %Para o controlador PD
% %Kd = K
% %Kp = (1/Zero - 1)*Kd/Ta
% 
% Kp_PD = (1/Zero_PD-1)*K_PD/Ta
% Ki_PD = 0;
% Kd_PD = K_PD
% 
% %Controlador PI
% %1 Zero = 1 / (Ki/Kp * Ta + 1)
% %1 Polo = 1
% 
% Zero_PI = 0.90;
% 
% num_PI = [1 -Zero_PI];
% den_PI = [1 -1];
% 
% [nump_PI,denp_PI] = series(nump,denp,num_PI,den_PI);
% G_PI = tf (nump_PI,denp_PI,Ta);
% figure
% rlocus (G_PI)
% zgrid
% 
% keyboard
% 
% K_PI = rlocfind (G_PI); %ganho do controlador PI
% 
% %Para o controlador PI
% %Kp = K
% %Ki = (1/Zero - 1)*Kp/Ta
% 
% Kp_PI = K_PI
% Ki_PI = (1/Zero_PI - 1)*K_PI/Ta
% Kd_PI = 0;
% 
% %O ruído
% 
% ruido_media = 0.011877972928933; 
% ruido_variancia = 0.1;
% 
% %A Saturação
% 
% saturacao_max = 5;
% saturacao_min = -5;
% 
% %A banda morta
% 
% banda_morta_ini = -2.3;
% banda_morta_fim = 2.3;
% 
% %O degrau
% 
% amplitude = 50;
% 
% %Chamando os SIMULINKS
% 
% discretoSIMULINK_P %controlador P
% discretoSIMULINK_PD %controlador PD
% discretoSIMULINK_PI %controlador PI
