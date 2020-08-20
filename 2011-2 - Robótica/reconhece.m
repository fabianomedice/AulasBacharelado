%%% banco de dados dos caracteres em binario (segundo o codigo 39)
codigo0=[0 0 0 1 1 0 1 0 0];%0
codigo1=[1 0 0 1 0 0 0 0 1];%1
codigo2=[0 0 1 1 0 0 0 0 1];%2
codigo3=[1 0 1 1 0 0 0 0 0];%3
codigo4=[0 0 0 1 1 0 0 0 1];%4
codigo5=[1 0 0 1 1 0 0 0 0];%5
codigo6=[0 0 1 1 1 0 0 0 0];%6
codigo7=[0 0 0 1 0 0 1 0 1];%7
codigo8=[1 0 0 1 0 0 1 0 0];%8
codigo9=[0 0 1 1 0 0 1 0 0];%9
codigo10=[1 0 0 0 0 1 0 0 1];%a
codigo11=[0 0 1 0 0 1 0 0 1];%b
codigo12=[1 0 1 0 0 1 0 0 0];%c
codigo13=[0 0 0 0 1 1 0 0 1];%d
codigo14=[1 0 0 0 1 1 0 0 0];%e
codigo15=[0 0 1 0 1 1 0 0 0];%f
codigo16=[0 0 0 0 0 1 1 0 1];%g
codigo17=[1 0 0 0 0 1 1 0 0];%h
codigo18=[0 0 1 0 0 1 1 0 0];%i
codigo19=[0 0 0 0 1 1 1 0 0];%j
codigo20=[1 0 0 0 0 0 0 1 1];%k
codigo21=[0 0 1 0 0 0 0 1 1];%l
codigo22=[1 0 1 0 0 0 0 1 0];%m
codigo23=[0 0 0 0 1 0 0 1 1];%n
codigo24=[1 0 0 0 1 0 0 1 0];%o
codigo25=[0 0 1 0 1 0 0 1 0];%p
codigo26=[0 0 0 0 0 0 1 1 1];%q
codigo27=[1 0 0 0 0 0 1 1 0];%r
codigo28=[0 0 1 0 0 0 1 1 0];%s
codigo29=[0 0 0 0 1 0 1 1 0];%t
codigo30=[1 1 0 0 0 0 0 0 1];%u
codigo31=[0 1 1 0 0 0 0 0 1];%v
codigo32=[1 1 1 0 0 0 0 0 0];%x
codigo33=[0 1 0 0 1 0 0 0 1];%z
codigo34=[1 1 0 0 1 0 0 0 0];%
codigo35=[0 1 1 0 1 0 0 0 0];%
codigo36=[0 1 0 0 0 0 1 0 1];%
codigo37=[1 1 0 0 0 0 1 0 0];%
codigo38=[0 1 1 0 0 0 1 0 0];%
codigo39=[0 1 0 1 0 1 0 0 0];%
codigo40=[0 1 0 1 0 0 0 1 0];%
codigo41=[0 1 0 0 0 1 0 1 0];%
codigo42=[0 0 0 1 0 1 0 1 0];%
codigo43=[0 1 0 0 1 0 1 0 0];%
%%% matriz para organizar os caracteres e facilitar a busca e comparaçao
codigox=[codigo0; codigo1; codigo2; codigo3; codigo4; codigo5; codigo6; codigo7; codigo8; codigo9; codigo10; codigo11; codigo12; codigo13; codigo14; codigo15; codigo16; codigo17; codigo18; codigo19; codigo20; codigo21; codigo22; codigo23; codigo24; codigo25; codigo26; codigo27; codigo28; codigo29; codigo30; codigo31; codigo32; codigo33; codigo34; codigo35; codigo36; codigo37; codigo38; codigo39; codigo40; codigo41; codigo42; codigo43];
%%% vetor com os caracteres
caracter=char('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '-', '.', ' ', '$', '/', '+', '%', '*');
%%% comparaçao da palavra proveniente do codigo de barras lido com o banco de dados
for c=1:length(codigox)
if palavra==codigox(c,:)
lido(x)=caracter(c,:);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%codigo0 a codigo 43 -> vetor contendo a representaçao do caracter em binario %
%codigox -> matriz contendo todas as representaçoes dos caracteres em binario %
%caracter -> vetor contendo os caracteres %
%palavra -> vetor binario com a palavra de 9 bits referente a 1 caracter %
%lido -> vetor contendo todos os caracteres lido %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%