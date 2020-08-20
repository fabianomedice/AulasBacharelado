-- Adaptado de Peter Ashenden, Digital Design, p�gs. 67-69.
library ieee;
use ieee.std_logic_1164.all;
entity Conv_BCD_7seg is
port ( bcd : in std_logic_vector(3 downto 0);
seg : out std_logic_vector(7 downto 1) );
end entity Conv_BCD_7seg;
architecture behavior of Conv_BCD_7seg is
begin
with bcd select
seg <= "1000000" when "0000", -- 0 (s� segmento g fica desligado)
"1111001" when "0001", -- 1 (segmentos b, c ficam ligados)
"0100100" when "0010", -- 2
"0110000" when "0011", -- 3
"0011001" when "0100", -- 4
"0010010" when "0101", -- 5 (s� segmentos b, e ficam desligados)
"0000010" when "0110", -- 6
"1111000" when "0111", -- 7
"0000000" when "1000", -- 8
"0010000" when "1001", -- 9
"0111111" when others; -- (para c�digos inv�lidos,
-- s� segmento g fica ligado)
end architecture behavior;