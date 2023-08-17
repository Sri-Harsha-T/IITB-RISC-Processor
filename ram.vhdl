LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ram is

	generic 
	(
		DATA_WIDTH : natural := 16;
		ADDR_WIDTH : natural := 8
	);

	port 
	(
		clk		: in std_logic;
		address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);--in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of ram is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal.	
	signal s_ram : memory_t;
	shared variable addr : natural range 0 to 2**ADDR_WIDTH -1;

	-- Register to hold the address 
	signal addr_reg : natural range 0 to 2**ADDR_WIDTH-1;

begin

	

	process(clk)
	begin
	addr := to_integer(unsigned(address( 7 DOWNTO 0)));
	if(rising_edge(clk)) then
		if(we = '1') then
			s_ram(addr) <= data;
		end if;

		-- Register the address for reading
		addr_reg <= addr;
	end if;
	end process;

	q <= s_ram(addr_reg);

end rtl;

