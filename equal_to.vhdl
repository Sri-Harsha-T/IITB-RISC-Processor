
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity equal_to is
	generic ( dw : integer := 16);
	port (
		A, B: in std_logic_vector(dw-1 downto 0);
		R: out std_logic);
end entity;

architecture equal_to_Arc of equal_to is
	signal int, temp: std_logic_vector(dw-1 downto 0);
begin
	int <= (A xor B);	
	
	--taking and of all bits in int
	temp(0) <= int(0);
    gen: for i in 1 to dw-1 generate
        temp(i) <= temp(i-1) or int(i);
    end generate; 
    
    R <= not temp(dw-1);
end equal_to_Arc;
