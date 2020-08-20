clc
clear all
close all

G1 = tf(20,[1 0]);
G2 = tf(1,[1/10 1]);
G3 = tf(1,[1/2000 1]);
Gs = G1*G2*G3
%definendo PD (um polo e um zero
p = 3000;
z = 3;

Gc= tf([1 -z], [1/p 1])
Gs = G1*G2*G3*Gc
rlocus(Gs)

return
sgrid
K = rlocfind(Gs)