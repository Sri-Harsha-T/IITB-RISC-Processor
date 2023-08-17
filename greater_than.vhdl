
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity greater_than is
	generic ( dw : integer := 16);
	port (
		A, B: in std_logic_vector(dw-1 downto 0);
		R: out std_logic);
end entity;

architecture Serial of greater_than is
	signal not_equal, temp2: std_logic_vector(dw-1 downto 0);
begin
	
	not_equal <= ((A and (not B)) or ((not A) and B));
	temp2(dw-1) <= (not not_equal(dw-1)) or A(dw-1); 
	gen: for i in dw-2 downto 0 generate
		temp2(i) <= ((A(i) or (not not_equal(i))) and temp2(i+1)); 
	end generate;
	
	R <= (temp2(0) and not_equal(0));
end architecture;
