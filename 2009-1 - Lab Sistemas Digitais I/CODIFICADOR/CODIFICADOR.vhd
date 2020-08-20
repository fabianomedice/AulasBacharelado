entity CODIFICADOR is
	port (INPUT: in bit_vector (7 downto 0);
			A: out integer range 0 to 7;
			VALIDO : out bit);
end CODIFICADOR;

architecture SIMPLES of CODIFICADOR is

begin

A <= 7 when INPUT(7) = '1' else
	 6 when INPUT(6) = '1' else
	 5 when INPUT(5) = '1' else
	 4 when INPUT(4) = '1' else
	 3 when INPUT(3) = '1' else
	 2 when INPUT(2) = '1' else
	 1 when INPUT(1) = '1' else
	 0;
	
VALIDO <= INPUT(7) or INPUT(6) or INPUT(5) or INPUT(4) or INPUT(3) or INPUT(2) or INPUT(1) or INPUT(0);

end SIMPLES;