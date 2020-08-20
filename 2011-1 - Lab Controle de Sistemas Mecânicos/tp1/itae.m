function [z]= itae(tempo,onda,valor_degrau)
tam=size(onda);
soma=0;
for i=1:tam(1)
    erro(i) = abs(valor_degrau-onda(i));
    k(i)=erro(i)*tempo(i);
    soma=soma+k(i);
end
z=soma;