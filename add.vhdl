-- A package consisting of adder elements
-- components include full_adder, carry generator, 16 bit adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package add is
	component full_adder is
		port(
			a, b, cin: in std_logic;
			s, p, g: out std_logic
		);
	end component;
	
	component adder is
		generic(
			wlen: integer := 16;
			glen: integer := 4
		);
		port(
			A, B: in std_logic_vector(wlen-1 downto 0);
			cin: in std_logic;
			cout, S: out std_logic_vector(wlen-1 downto 0)
		);
	end component;
	
	component carry_generate is
		generic(glen: integer := 4);
		port(
			P, G: in std_logic_vector(glen-1 downto 0);
			cin: in std_logic;
			cout: out std_logic_vector(glen-1 downto 0));
	end component;
end package;