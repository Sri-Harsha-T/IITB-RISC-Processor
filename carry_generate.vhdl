-- entity to generate the carry bit for carry-look-ahead implementation 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity carry_generate is
	generic(glen: integer := 4);
	port(
		P, G: in std_logic_vector(glen-1 downto 0);
		cin: in std_logic;
		cout: out std_logic_vector(glen-1 downto 0)
	);
end entity;

architecture carry_generate_arch of carry_generate is
	signal C: std_logic_vector(glen downto 0);
begin
	
	C(0) <= cin;
	logic:
	for i in 1 to glen generate
		C(i) <= G(i-1) or (P(i-1) and C(i-1)); 
	end generate;

	cout <= C(glen downto 1);
end architecture;