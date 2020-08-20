function [k]=lcsm_ganho(x,y)
y_final=y(end);
y_inicial=0;
x_final=x(end);
x_inicial=0;
k=(y_final-y_inicial)/(x_final-x_inicial);
