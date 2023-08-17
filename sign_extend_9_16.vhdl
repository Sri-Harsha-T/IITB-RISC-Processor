library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity sign_extend_9_16 is
	port(
		input: in std_logic_vector(8 downto 0);
		output: out std_logic_vector(15 downto 0));
end entity;
architecture sign_extend_9_16_arch of sign_extend_9_16 is
begin
	output(8 downto 0) <= input;
	extend:
	for i in 9 to 15 generate
		output(i) <= input(8);
	end generate;
end architecture;
