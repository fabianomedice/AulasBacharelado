clc
close all

Ta = 10/1000; %tempo de amostragem

%A planta

% y(z)/x(z) = (0.0154 z^6 -0.1308 z^5 -0.3082 z^4 +1.1892 z^3 + 1.6618 z^2 +1.5483 z + 0.2994) / (z^6 -0.1106 z^5 -0.2860 z^4 -0.4816 z^3 +0.5898 z^2 -0.3666 z +0.2016)

nump = [0.0154 -0.1308 -0.3082 1.1892 1.6618 1.5483 0.2994];
denp = [1 -0.1106 -0.2860 -0.4816 0.5898 -0.3666 0.2016];

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
% %O ru�do
% 
% ruido_media = 0.011877972928933; 
% ruido_variancia = 0.1;
% 
% %A Satura��o
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
