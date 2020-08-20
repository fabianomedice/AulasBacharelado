clc;
clear;
r= [1:20];
a= pi*r.^2;
fprintf('Raio\t\tArea\n')
for b=1:1:20
    fprintf('%f\t%f\n',r(b),a(b))
end
fprintf('O grafico correspondente eh\n')
plot(r,a)
xlabel('raio')
ylabel('area')