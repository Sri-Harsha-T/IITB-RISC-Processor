library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fulladder is
	port(
		a, b, c0: in std_logic;	--input bits to be added and input carry
		c1, s: out std_logic);	--output carry and sum bit
end entity;

architecture fulladder_arc of fulladder	is
	signal abxor: std_logic;	--xor of a and b
begin

	abxor <= (((not a) and b) or (a and (not b)));	
	s <= (((not abxor) and c0) or (abxor and (not c0)));
	c1 <= (((a and b) or (a and c0)) or (c0 and b));	

end fulladder_arc;	 	
