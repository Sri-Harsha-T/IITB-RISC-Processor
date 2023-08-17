
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity Sub16 is
	port(
		A, B: in std_logic_vector(15 downto 0);	--input numbers to be added
		S: out std_logic_vector(15 downto 0);	--result
		c16: out std_logic);	--ouput carry
end entity;

architecture myOwn of Sub16 is
	signal notB: std_logic_vector(15 downto 0);
	signal cint : std_logic;
begin
	
	notB <= not B;
	
	adder1: adder8Bit port map( A => A(7 downto 0), B => notB(7 downto 0), c0 => '1', c8 => cint, S => S(7 downto 0));	--8-bit adder
	adder2: adder8Bit port map( A => A(15 downto 8), B => notB(15 downto 8), c0 => cint, c8 => c16, S => S(15 downto 8));	--8-bit adder
	
end architecture;
