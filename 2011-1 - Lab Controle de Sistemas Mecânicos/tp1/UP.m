function [k]= UP(onda)
xmax=max(onda);
xend=onda(end);
k=100*(xmax-xend)/xend;
