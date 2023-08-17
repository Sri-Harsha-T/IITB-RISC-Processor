library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decr4 is
	port(
		A : in std_logic_vector(3 downto 0);
		B : out std_logic_vector(3 downto 0)
	);
end entity;

architecture decr4_Arc of decr4 is
	signal c1, c2, c3 : std_logic;
	
begin

	B(0) <= (not A(0));	
	c1 <= (A(0));		
	
	B(1) <= ((A(1) and c1) or ((not A(1)) and (not c1)));
	c2 <= (A(1) or c1);
	
	B(2) <= ((A(2) and c2) or ((not A(2)) and (not c2)));
	c3 <= (A(2) or c2);
	
	B(3) <= ((A(3) and c3) or ((not A(3)) and (not c3)));
	
end decr4_Arc;
