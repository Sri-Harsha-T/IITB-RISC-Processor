library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity sign_extend_6_16 is
	port(
		input: in std_logic_vector(5 downto 0);
		output: out std_logic_vector(15 downto 0));
end entity;
architecture sign_extend_6_16_arch of sign_extend_6_16 is
begin
	output(5 downto 0) <= input;
	extend:
	for i in 6 to 15 generate
		output(i) <= input(5);
	end generate;
end architecture;
