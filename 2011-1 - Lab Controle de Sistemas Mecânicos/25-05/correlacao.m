clc
close all
clear all

N = 1001;
x = randn(1,N);
y = [0 0 0 x];
y = y(1:N);

c = crosscorr(x,y);
atrasos = -(N-1):1:(N-1)

plot(atrasos,c)
grid on
