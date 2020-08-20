clc;
clear all;
close all;
k1=1;
zeta1=0.25;
wn1=6;
num=[k1*wn1^2];
den=[1 2*zeta1*wn1 wn1^2];
t=linspace(0,5,3000)';
x=ones(size(t));
y=lsim(num,den,x,t);
ub=1.02*y(end)*ones(size(t));
lb=0.98*y(end)*ones(size(t));
plot(t,y,t,ub,'k--',t,lb,'k--')
grid on
k=lcsm_ganho(x,y)
figure(2)
plot(t,x-y)
figure(3)
plot(t,abs(x-y))
figure(4)
plot(t,t.*abs(x-y))
itae=sum(t.*abs(x-y))
