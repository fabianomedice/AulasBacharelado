clc
close all
clear all

K = 2;
tau = 4;
Gs = tf(K,[tau 1])
figure(1)
rlocus(Gs)
sgrid

Ta = 0.2; %tempo de amostragem
Gz = c2d(Gs,Ta,'zoh') 
%Gz = c2d(Gs,Ta,'tustin')
figure(2)
rlocus(Gz)
zgrid
