-- implementing the carry look ahead adder
-- wlen : word length, glen: group length
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.add.all;

entity adder is
	generic(
		wlen: integer := 16;
		glen: integer := 4
	);
	port(
		A, B: in std_logic_vector(wlen-1 downto 0);
		cin: in std_logic;
		S, cout: out std_logic_vector(wlen-1 downto 0)
	);
end entity;

architecture adder_arc of adder is
	signal P, G: std_logic_vector(wlen-1 downto 0);
	signal C: std_logic_vector(wlen downto 0);
begin
	C(0) <= cin;
	add_l:
	for index in 0 to wlen-1 generate
		ADDX: full_adder
			port map(
				a => A(index), b => B(index), cin => C(index),
				s => S(index), p => P(index), g => G(index)
			);
	end generate;
	
	car_l:
	for index in 1 to (wlen/glen) generate
		CARRYX: carry_generate
			generic map(glen)
			port map(
				P => P((index)*glen-1 downto (index-1)*glen),
				G => G((index)*glen-1 downto (index-1)*glen),
				cin => C((index-1)*glen), cout => C(index*glen downto (index-1)*glen+1)
			);
	end generate;
	
	cout <= C(wlen downto 1);
	
end architecture;