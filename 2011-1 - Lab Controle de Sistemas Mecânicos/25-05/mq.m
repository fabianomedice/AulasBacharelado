clc
close all
clear all

N = 10000;

x = rand(N,1);
x(x>=0.5) = 1;
x(x<0.5) = 0;

y = zeros(size(x));

for k = 16:N
    y(k) = 0.3*x(k-15) + 0.2*y(k-1) + 0.1*y(k-2) + 2.3 + 0.01*randn(1,1);
end
figure(1)
c = crosscorr(x,y);
atrasos = -(N-1):1:(N-1)
stem(atrasos,c)
grid on

figure(2)
c = crosscorr(y,y);
atrasos = -(N-1):1:(N-1)
stem(atrasos,c)
grid on

       %x[k-15]   x[k-16]    x[k-17]    y[k-1]     y[k-2]      y[k-3]   [1]
A1 = [x(3:N-15)   x(2:N-16)   x(1:N-17)  y(17:N-1)  y(16:N-2)  y(15:N-3) ones(N-17,1)];
A2 = [x(3:N-15)   y(17:N-1)  y(16:N-2)  y(15:N-3) ones(N-17,1)];
ym = y(18:N);
teta1 = A1\ym
teta2 = A2\ym

yc1 = A1*teta1; % saida calculada pelo modelo
yc2 = A2*teta2;
figure(3)
plot(ym,'k')
grid on; hold on
plot(yc1,'r')

residuo1 = ym - yc1;
residuo2 = ym - yc2;
figure(4)
plot(residuo1)
grid on

%akaike information criterion
k1 = length(teta1); %numero de parametros do modelo
AIC1 = N*log(sum(residuo1.^2)) + 2*k1
k2 = length(teta2); %numero de parametros do modelo
AIC2 = N*log(sum(residuo2.^2)) + 2*k2