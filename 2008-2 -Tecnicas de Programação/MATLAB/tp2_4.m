clc
clear
tempo = input('Digite o numero de horas trabalhadas: ')
salario = input ('Digite o salario/hora: ')
salario_bruto = tempo * salario;
if salario_bruto < 100
    desconto = 0;
end
if salario_bruto >= 100 & salario_bruto <200
    desconto = 0.1 * salario_bruto;
end
if salario_bruto >200
    desconto = 0.2 * salario_bruto;
end
salario_liquido=salario_bruto-desconto;
fprintf('O salario liquido foi %f',salario_liquido)