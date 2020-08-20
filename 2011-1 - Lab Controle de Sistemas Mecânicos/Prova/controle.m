clc
close all

%A planta

% y(z)/x(z) = 1.0005 / (z^2- 0.3517*z)

nump = [0 0 1.0005] ;
denp = [1 -0.3517 0];

Gz = tf (nump,denp,Ts)
figure
rlocus (Gz)
zgrid
zeros_Gz = zero(Gz)
polos_Gz = pole(Gz)

%Controlador PI
%1 Zero = 1 / (Ki/Kp * Ta + 1)
%1 Polo = 1

Zero_PI = 0.4;

num_PI = [1 -Zero_PI];
den_PI = [1 -1];

Gc = tf (num_PI,den_PI,Ts)

[nump_PI,denp_PI] = series(nump,denp,num_PI,den_PI);
G_PI = tf (nump_PI,denp_PI,Ts);
figure
rlocus (G_PI)
zgrid

keyboard

K_PI = rlocfind (G_PI); %ganho do controlador PI

%Para o controlador PI
%Kp = K
%Ki = (1/Zero - 1)*Kp/Ta

Kp_PI = K_PI
Ki_PI = (1/Zero_PI - 1)*K_PI/Ts
Kd_PI = 0;

GMA = K_PI*Gc*Gz;
GMF = GMA / (1 + GMA);
t= 0:Ts:40;
step (GMF,t)

