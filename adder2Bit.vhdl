-- 2-bit ripple carry adder
library ieee;
library work;
use work.basic.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder2Bit is
	port(
		a0, a1, b0, b1, c0: in std_logic;	
		s0, s1, c2: out std_logic	
	);
end entity;

architecture adder2Bit_arc of adder2Bit is
	signal c1: std_logic;
begin
	add1: fullAdder port map( a =>a0, b=>b0, s => s0, c0 => c0, c1 => c1);	
	add2: fullAdder port map( a =>a1, b=>b1, s => s1, c0 => c1, c1 => c2);	
end adder2Bit_arc;