-- integrating datapath and controlpath
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bootload is 
	port(
		start, clk, reset, RX: in std_logic;
		address,data: out std_logic_vector(15 downto 0);
		enable, finish: out std_logic
	);
end entity;

architecture bootload_arch of bootload is
	component control_bootload is
		port(
			start, clk, reset: in std_logic;
			T: out std_logic_vector(6 downto 0);
			S: in std_logic_vector(2 downto 0);
			finish: out std_logic
		);
	end component;
	
	component data_bootload is
		port(
			clk, reset, RX: in std_logic;
			T: in std_logic_vector(6 downto 0);
			S: out std_logic_vector(2 downto 0);
			address,data: out std_logic_vector(15 downto 0);
			enable: out std_logic
		);
	end component;

	signal T: std_logic_vector(6 downto 0);
	signal S: std_logic_vector(2 downto 0);
begin
	dp: data_bootload
	port map(
		clk => clk, reset => reset, RX => RX, T => T,
		S => S, address => address, data => data, enable => enable
	);
		
	cp: control_bootload
	port map(
		clk => clk, reset => reset, start => start,
		T => T, S => S, finish => finish
	);
		
end architecture;