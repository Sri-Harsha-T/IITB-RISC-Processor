-- 8-bit ripple carry adder using cascaded 2-bit adders
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.basic.all;

entity adder8Bit is
	port(
		A, B: in std_logic_vector(7 downto 0);
		c0: in std_logic;
		S: out std_logic_vector(7 downto 0);
		c8: out std_logic
	);
end entity;

architecture adder8Bit_arc of adder8Bit is
	signal c2, c4, c6: std_logic;
begin
	add1: adder2Bit port map( a0 =>A(0), a1 =>A(1), b0 =>B(0), b1 =>B(1), c0 =>c0, c2 =>c2, s0 =>S(0), s1 =>S(1));
	add2: adder2Bit port map( a0 =>A(2), a1 =>A(3), b0 =>B(2), b1 =>B(3), c0 =>c2, c2 =>c4, s0 =>S(2), s1 =>S(3));
	add3: adder2Bit port map( a0 =>A(4), a1 =>A(5), b0 =>B(4), b1 =>B(5), c0 =>c4, c2 =>c6, s0 =>S(4), s1 =>S(5));
	add4: adder2Bit port map( a0 =>A(6), a1 =>A(7), b0 =>B(6), b1 =>B(7), c0 =>c6, c2 =>c8, s0 =>S(6), s1 =>S(7));

end adder8Bit_arc;