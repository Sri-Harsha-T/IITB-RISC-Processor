-- implementing clock simulation
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.basic.all;

entity clk_divider is
	generic(ratio: integer := 5);
	port(
		clk_in: in std_logic;
		clk_out: out std_logic);		
end entity;

architecture clk_divider_arch of clk_divider is
	signal inf, outf: std_logic_vector(ratio-1 downto 0);
	
begin
	inf <= std_logic_vector(unsigned(outf) + 1);
	process(clk_in)
	begin
	
		if(clk_in = '1') then
			outf <= inf;
		end if;
	end process;
	clk_out <= outf(ratio - 1);
	
end architecture;

