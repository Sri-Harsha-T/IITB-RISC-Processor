library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_1164.all;

entity p_encoder is
	generic(input_width: integer := 16);
	port(
		input: in std_logic_vector(15 downto 0);
		output: out std_logic_vector(3 downto 0);
		valid: out std_logic);
end entity;

architecture behave_ov of p_encoder is
	signal output_temp: std_logic_vector(output'length-1 downto 0);
begin

	main: process(input)
	begin
		output_temp <= (others => '0');
		for i in 15 downto 0 loop
			if input(i) = '1' then
				output_temp <= std_logic_vector(to_unsigned(i,output'length));
			end if;
		end loop;
	end process;
	
	output <= output_temp;
	valid <= '0' when (to_integer(unsigned(output_temp)) = 0 and input(0) = '0') else '1';
	
end architecture;