clc
clear

nota= input('Digite a nota do aluno: ')
if nota<100 & nota > 0
    if nota>90
        fprintf('A nota esta otima')
    end
    if 90>=nota & nota>75
        fprintf('A nota esta boa')
    end
    if 75>=nota & nota>=60
        fprintf('A nota esta regular')
    end
    if nota<60
        fprintf('A nota esta insuficiente')
    end
else
    fprintf('A nota digitada esta errada')
end