clc;
clear;
x=input('Digite um numero natural entre 999 e 10000 ');
if x>999 & x<10000
    uni=mod(x,10);
    dez=mod(x,100);
    dez=(dez-uni)/10;
    cen=mod(x,1000);
    cen=(cen-(dez*10)-uni)/100;
    mil=mod(x,10000);
    mil=(mil-(cen*100)-(dez*10)-uni)/1000;
    if uni==mil
        if dez==cen
            fprintf('O numero %d eh palindromo',x)
        else
            fprintf('O numero %d n eh palindromo',x)
        end
    else
        fprintf('O numero %d n eh palindromo',x)
    end
else
    fprintf('O numero %d n esta no intervalo',x)
end