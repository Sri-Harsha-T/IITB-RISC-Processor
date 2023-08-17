
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity my_reg is
	generic ( dw : integer);
	port(
		clk, ena, clr: in std_logic;
		Din: in std_logic_vector(dw-1 downto 0);
		Dout: out std_logic_vector(dw-1 downto 0));
end entity;

architecture myOwn of my_reg is
begin
	process(clk, clr)	
	begin
		if(clk'event and clk='1') then
			if (ena='1') then
				Dout <= Din;
			end if;
		end if;
		if(clr = '1') then
			Dout <= (others => '0');
		end if;
	end process;
	
end myOwn;		
