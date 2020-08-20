function [t]= Tp(tempo,onda)
x=max(onda);
tam=size(onda);
for i=1:tam(1)
    y=onda(i);
   if y==x
       indice=i;
   end
end
t=tempo(indice);