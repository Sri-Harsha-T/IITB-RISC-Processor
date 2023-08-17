-- implementing bootloading logic for control path
-- intialising control pins on starting




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_bootload is
	port(
		start, clk, reset: in std_logic;
		T: out std_logic_vector(6 downto 0);
		S: in std_logic_vector(2 downto 0);
		finish: out std_logic
	);
end entity;

architecture control of control_bootload is
	type fsm_state is (S0, S1, S2_1, S2_2, S3_1, S3_2, S4);
	signal Q, nQ: fsm_state := S0;
begin

	clock: process(clk)
	begin
		if(clk'event and clk = '1') then	
			Q <= nQ;
		end if;
	end process;
	
	main: process(S, reset, start, Q)
	begin
		T <= (others => '0');
		finish <= '0';
		if (reset = '1') then
			nQ <= S0;
		else
			nQ <= Q;
			case Q is
				when S0 =>
					if (start = '1') then nQ <= S1;
					end if;
				when S1 =>
					if (S(0) = '1') then 
						if (S(1) = '1') then nQ <= S4;
						else 
							nQ <= S2_1;
							T(4) <= '1';
							T(5) <= '1';
						end if;
					end if;
				when S2_1 =>
					if (S(0) = '1') then 
						T(0) <= '1';
						nQ <= S2_2;
					end if;
				when S2_2 =>
					if (S(0) = '1') then 
						T(1) <= '1';
						nQ <= S3_1;
					end if;
				when S3_1 =>
					if (S(0) = '1') then
						T(2) <= '1';
						T(3) <= '1';
						T(5) <= '1';
						nQ <= S3_2;
					end if;
				when S3_2 =>
					if (S(0) = '1') then nQ <= S3_1;
						T(0) <= '1';
						T(1) <= '1';
						T(3) <= '1';
						T(6) <= '1';
						if (S(2) = '1') then nQ <= S1;
						end if;
					end if;
				when S4 =>
					finish <= '1';
					nQ <= S0;
				when others =>
					nQ <= S4;
			end case;
		end if;	
	end process;
end architecture;
