entity semaforo_PLD is
	port
	(
		--Input ports
		D,A,B,C		:in bit;
		
		--Output ports
		Sa,Sb,Sc	:out bit
	);
end semaforo_PLD;

architecture equacoes of semaforo_PLD is
begin
	Sa <= D or (not A and B ) or (not B and C);
	Sb <= D or A or not B;
	Sc <= D or B or not C;
end equacoes;