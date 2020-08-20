clc
clear all
close all

load data %carregando os arquivos da prova

format long

i = 6; %dado pelo professor

rt_Command = x;
rt_Output = y(:,i);
N = 5000;

%para achar os atrasos de x em relaçao ao y

figure
cx = crosscorr(rt_Command,rt_Output);
atrasos = -(N-1):1:(N-1);

stem(atrasos,cx)
grid on

%para achar os atrasos de y em relaçao ao proprio y

figure
cy = crosscorr(rt_Output,rt_Output);
atrasos = -(N-1):1:(N-1);

stem(atrasos,cy)
grid on

keyboard %parar o programa para esperar que a equação a diferenças seja feita

%tirando os Minimos Quadrados

%montar a equação a diferenças da planta Y = A x Teta
%y[k] = x[k-1] + x[k-2] + y[k-1] + constante

A1 = [rt_Command(2:N-1) rt_Command(2:N-1) rt_Output(2:N-1) ones(N-2,1)];
Y = rt_Output(3:N);
Teta1 = A1\Y

Yc1 = A1*Teta1; % saida calculada pelo modelo
Residuo1 = Y - Yc1;
k1 = length(Teta1); %numero de parametros do modelo
AIC1 = N*log(sum(Residuo1.^2)) + 2*k1 %akaike information criterion

keyboard %parar o programa para esperar que a 2 equação a diferenças seja feita

%tirando os Minimos Quadrados

%montar a equação a diferenças da planta Y = A x Teta
%y[k] = x[k-2] + y[k-1] + constante

A2 = [rt_Command(2:N-1) rt_Output(2:N-1) ones(N-2,1)];
Teta2 = A2\Y

Yc2 = A2*Teta2; % saida calculada pelo modelo
Residuo2 = Y - Yc2;
k2 = length(Teta2); %numero de parametros do modelo
AIC2 = N*log(sum(Residuo2.^2)) + 2*k2 %akaike information criterion

%a planta encontrada foi:
%media do ruido = constante = -0.10569208604988
% y[k] = 1.00052272410812*x[k-2] + 0.35170790490423*y[k-1] -0.10569208604988
% y[k] - 0.35170790490423*y[k-1] = 1.00052272410812*x[k-2] 
% y[k+2] - 0.35170790490423*y[k+1] = 1.00052272410812*x[k] 
% z^2 y(z) - 0.35170790490423*z y(z) = 1.00052272410812*x(z)
% (z^2- 0.35170790490423*z) y(z) = 1.00052272410812*x(z)
% y(z)/x(z) = 1.00052272410812 / (z^2- 0.35170790490423*z)