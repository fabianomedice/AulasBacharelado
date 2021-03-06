clc
clear all
close all

G1 = tf(20,[1 0]);
G2 = tf(1,[1/10 1]);
G3 = tf(1,[1/2000 1]);
Gs = G1*G2*G3
%definendo PD (um polo e um zero
p = -200;
z1 = -3 + 3*i;
z2 = -3 - 3*i;

Gc= tf([1 -(z1+z2)  z1*z2], [-1/p 1 0])



Gs = G1*G2*G3*Gc
rlocus(Gs)

return
sgrid
K = rlocfind(Gs)

A =  [-1/p                0                  1 ; 
    ((1/p)*(z1+z2)-1)    1/p          -(z1+z2)    ; 
    (1/p)*z1*z2           1           -z1*z2]
b = [K ; 0; 0]
x = A\b %ou inv(a)*b
