clc
clear all
close all
n_p = 4;
d_p = [0.1 1];
teta = 0.05;
Gs = tf(n_p,d_p,'InputDelay',teta);
ordem = 1;
[n_tm,d_tm] = pade(teta,ordem);
[num,den] = series(n_tm,d_tm,n_p,d_p); %g(s) aprox

z = -9; p = 0;
nC = [1 -z]; dC = [1 -p];
[nMA,dMA] = series(num,den,nC,dC);

t=linspace(0,1,1000)';
y1 = step(num,den,t); %simulaça de g(s) aproximado
figure(1)
rlocus(nMA,dMA); hold on
sgrid

keyboard

[Kp] = rlocfind(nMA,dMA)
[nMF,dMF] = feedback(Kp*nMA,dMA,1,1);
y3 = step(nMF,dMF,t);
figure(2); plot(t,y1,t,y3)
legend('antes','depois')
grid on
