function [k]= epsilon(UP)
num=((log(UP/100))^2);
den=(log(UP/100)^2+pi^2);
k=((num/den)^(1/2));
