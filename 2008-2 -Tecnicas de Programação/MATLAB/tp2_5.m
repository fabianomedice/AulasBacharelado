clc;
clear;
x=input('Digite um numero natural entre 100 e 999 ');
if x>99&X<1000
    uni=mod(x,10);
    dez=mod(x,100);
    dez=(dez-uni)/10;
    cen=mod(x,1000);
    cen=(cen-(dez*10)-uni)/100;
    fprintf('O numero de unidades = %d,dezenas = %d, centenas = %d',uni,dez,cen)
else
    fprintf('O numero n esta no intervalo pedido')
end