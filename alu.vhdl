-- arithmetic and logical unit implemented
-- all instructions related to addition and logical nand are implemented in the component
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.add.all;

entity alu is
	generic(wlen: integer := 16);
	port(
		i1, i2: in std_logic_vector(wlen-1 downto 0);
		o1: out std_logic_vector(wlen-1 downto 0);
		cin, sel: in std_logic;
		CY, OV, Z: out std_logic
	);
end entity;

architecture behave of alu is
	signal temp,output_add,C: std_logic_vector(wlen-1 downto 0);
begin
	
	add1: adder
		generic map(wlen,4)
		port map(
			A => i1, B => i2,
			cin => cin, S => output_add, Cout => C
		);
			
	CY <= C(wlen-1);
	OV <= (C(wlen-1) xor C(wlen - 2));
	
	process(i1,i2,sel,output_add)
	begin
		if (sel = '0') then
			temp <= output_add;
		else
			temp <= i1 nand i2;
		end if;
	end process;
	
	Z <= '1' when (to_integer(unsigned(temp)) = 0) else '0';
	o1 <= temp;		
end architecture;