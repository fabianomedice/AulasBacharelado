function [k]= Ts(tempo,onda)
tam=size(onda);
j=1;
for i=1:tam(1)-1
    if abs(onda(i)) > abs(onda(i+1)) %achar pico
        if abs(onda(i)) > abs(onda(i-1)) %ver se não é descida
            y=abs(100*(onda(i)-onda(end))/onda(end));
            if y<2
                indice(j)=i;
                j=j+1;
            end
        end
    end
end
k = tempo(indice(1));