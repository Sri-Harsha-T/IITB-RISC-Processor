-- implementing control path logic
-- making a finite state machine with 22 states

-- Transfer Signal Mapping--
	--
	-- T(0)		: Data Memory Address
	--		0 	- D2
	--		1 	- ALU_S
	--
	-- T(1)		: Instruction Register Enable
	-- T(2)		: Register File Write Enable
	-- T(3)		: LS_Multiple Write Enable
	-- T(4)		: LS_Multiple Set-Zero
	-- T(5)		: Data Memory Write Enable
	-- T(7)		: T1 Register Enable
	-- T(8)		: T2 Register Enable
	-- T(9)		: PC Register Enable
	-- T(10)	: Flags Set
	-- T(11)	: A2 Input Select
	--		0 	- I(11-9)
	--		1	- PE
	--
	-- T(13:12)	: A3 Input Select
	--		00 - "111"
	--		01 - I(11-9)
	--		10 - PE
	--		11 - I(5-3)
	--
	-- T(16:14)	: D3 Input Select
	--		000 - PC
	--		001 - T1
	--		010 - LS
	--		011 - T2
	--		100 - R7
	--		101 - Data Memory Data Out
	--
	-- T(19:17)	: ALU_B Input Select
	--		000 - 0
	--		001 - 1
	--		010 - E2
	--		011 - SE(6-16)
	--		100 - SE(9-16)
	-- 		101 - T2
	--
	-- T(21:20)	: ALU_A Input Select
	--		00	- T2
	--		01	- T1
	--		10	- E1
	--		11	- R7
	--
	-- T(22)	: PC_IN Multiplexor Signal
	--		1 - ALU Output
	--		0 - D1
	--
	-- T(23)	: T1 Input Select
	--		1 - ALU Output
	--		0 - D2
	--
	-- T(24)	: Op_Code Forwarding
	--		1 - Forwarded
	--		0 - From IR
	-- T(25)	: T2 Input Select
	--		1 - ALU Output
	--		0 - D2
	--
	
	-- Predicate Signal Mapping--
	--
	-- S(0)	: InValid_Next Signal from ls_multiple
	-- S(1)	: Carry
	-- S(2)	: Zero
	-- S(3)	: Bit B
	-- S(4)	: Equality
	--
	
	--Instruction Memory
	--ins_mem: rom
	--	port map(q => DO_IM, address => A_IM, clock => clk); --aclr => reset);


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity control_path is
	port(
		reset, clk, bootload: in std_logic; 
		op_code: in std_logic_vector(3 downto 0);
		condition: in std_logic_vector(1 downto 0);
		T: out std_logic_vector(25 downto 0);
		boot: out std_logic;
		C, OV, Z, invalid_next, eq, B, finish: in std_logic
	);
end entity;

architecture fsm of control_path is
	type fsm_state is (B0, B1, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16,S17,S18, S19);
	signal Q, nQ: fsm_state := S0;
begin

	clocked:
	process(clk, nQ)
	begin
		if (clk'event and clk = '1') then
			Q <= nQ;
		end if;
	end process;
	
	outputs:
	process(op_code, Q)
	begin
		T <= (others => '0');
		boot <= '0';
		case Q is
			when B0 => 
				boot <= '1';
			when B1 => 
				boot <= '1';
		    when S0 => 
				T <= (others => '0');
			when S1 =>
				T(1) <= '1';					--Instruction Register Enable	
				T(9) <= '1';					--Enable PC Register
				T(19 downto 17) <= "001";		--ALU_B = 1
				T(21 downto 20) <= "11"; 		--ALU_A = R7
				T(22) <= '1';					--Send ALU Output to PC
				T(24) <= '1';					--Fetch OpCode from Memory Output
			when S2 =>
				T(0) <= '1';					--A_DM = D2
				T(3) <= '1';					--Send Input to the PE
				T(6) <= '1';
				T(7) <= '1';					--Enable T1
				T(11) <= '0';					--A2 = I(9-11)
				T(23) <= '0';					--Put D2 in T1
			when S3 =>
				T(7) <= '1';					--Enable T1	
				T(10) <= '1';					--Set Flags according to the Instruction
				T(19 downto 17) <= "010";		--ALU_B = E2
				T(21 downto 20) <= "10";		--ALU_A = E1
				T(23) <= '1';					--Put ALU_S in T1
			when S4 =>
				T(2) <= '1';					--Enable Register Write	
				T(13 downto 12) <= "11";		--A3 = I(6-8)/I(3-5)
				T(16 downto 14) <= "001";		--D3 = T1
			when S5 =>
				T(2) <= '1';					--Enable Register Write	
				T(13 downto 12) <= "00";		--A3 = "111"
				T(16 downto 14) <= "000";		--D3 = PC
				T(19 downto 17) <= "000";		--ALU_B = 0
				T(21 downto 20) <= "00";		--ALU_A = T2				
			when S6 =>
				T(2) <= '1';					--Enable Register Write	
				T(13 downto 12) <= "01";		--A3 = I(9-11)
				T(16 downto 14) <= "010";		--D3 = LS
			when S7 =>
				T(0) <= '1';					--A_DM = ALU_S	
				T(5) <= '1';					--Data Memory Write Enable
				T(7) <= '1';					--Enable T1
				T(10) <= '1';					--Set flags according to the instruction
				T(19 downto 17) <= "011";		--ALU_B = SE(6-16)
				T(21 downto 20) <= "10";		--ALU_A = E1
				T(23) <= '1';					--T1 = ALU_S
			when S8 =>
				T(2) <= '1';					--Enable Register Write	
				T(8)  <= '1';					--Enable T2
				T(13 downto 12) <= "01";		--A3 = I(9-11)
				T(16 downto 14) <= "101";		--D3 = DM_DO
			when S9 =>
				T(2) <= '1';					--Enable Register Write	
				T(13 downto 12) <= "00";		--A3 = "111"
				T(16 downto 14) <= "000";		--D3 = PC
			when S10 =>
				T(8)  <= '1';					--Enable T2		
			when S11 =>
				T(0) <= '1';					--A_DM = ALU_S
				T(2) <= '1';					--Enable Register Write
				T(4) <= '1';					--LS Multiple Set Zero
				T(7) <= '1';					--Enable T1
				T(13 downto 12) <= "10";		--A3 = PE
				T(16 downto 14) <= "011";		--D3 = T2
				T(19 downto 17) <= "001";		--ALU_B = 1
				T(21 downto 20) <= "01";		--ALU_A = T1
				T(23) <= '1';					--T1 = ALU_S	
			when S12 =>
				T(5) <= '1';					--Data Memory Write Enable
				T(6) <= '1';					--A_DM = T1
				T(11) <= '1';					--A2 = PE
			when S13 =>
				T(4) <= '1';					--LS Multiple Set Zero
				T(7) <= '1';					--Enable T1
				T(19 downto 17) <= "001";		--ALU_B = 1
				T(21 downto 20) <= "01";		--ALU_A = T1
				T(23) <= '1';					--T1 = ALU_S
			when S14 =>
				T(9) <= '1';					--Enable PC	
				T(19 downto 17) <= "011";		--ALU_B = SE(6-16)
				T(21 downto 20) <= "11";		--ALU_A = R7
				T(22) <= '1';					--PC = ALU_S
			when S15 =>
				T(2) <= '1';					--Enable Register Write	
				T(13 downto 12) <= "01";		--A3 = I(9-11)
				T(16 downto 14) <= "000";		--D3 = PC
				T(19 downto 17) <= "100";		--ALU_B = SE(9-16)
				T(21 downto 20) <= "11";		--ALU_A = R7
				T(22) <= '1';					--PC = ALU_S
			when S16 =>
				T(2) <= '1';					--Enable Register Write
				T(9) <= '1';					--Enable PC	
				T(13 downto 12) <= "01";		--A3 = I(9-11)
				T(16 downto 14) <= "000";		--D3 = PC
				T(22) <= '0';					--PC = D1
			when S17 =>
				T(8)  <= '1';					--Enable T2	
				T(19 downto 17) <= "101";		--ALU_B = T2
				T(21 downto 20) <= "00";		--ALU_A = T2
				T(25) <= '1';					--T2 = ALU_S
			when S18 =>
				T(8)  <= '1';					--Enable T2	
				T(19 downto 17) <= "101";		--ALU_B = T2
				T(21 downto 20) <= "01";		--ALU_A = T1
				T(25) <= '1';					--T2 = ALU_S
			when S19 =>
				T(2) <= '1';					--Enable Register Write	
				T(7) <= '1';					--Enable T1
				T(9) <= '1';					--Enable PC
				T(11) <= '0';					--A2 = I(9-11)
				T(19 downto 17) <= "100";		--ALU_B = SE(9-16)
				T(21 downto 20) <= "01";		--ALU_A = T1
				T(22) <= '1';					--PC = ALU_S
				T(23) <= '0';					--Put D2 in T1
			when others =>
												--Do Nothing
		end case;
	end process;
	next_state:
	process(op_code, condition, C, OV, Z, invalid_next, eq, B, reset, Q, finish, bootload)
	begin
		nQ <= Q;
		case Q is
			when B0 => 
				nQ <= B1;
			when B1 =>
				if (finish = '1') then nQ <= S0;
				end if;
			when S0 => 
				nQ <= S1;
			when S1 =>
				case op_code is
					when "0011" => 
						nQ <= S6;	
					when "1001" =>	
						nQ <= S15;
					when "1010" => 
						nQ <= S16;
					when "1011" => 
						nQ <= S19;
					when others =>	
						nQ <= S2;
				end case;
			when S2 =>
				case op_code is
					when "0000" => 
						nQ <= S7;
					when "0001"=>
						case condition is
							when "00" => 
								nQ <= S3;
							when "10" =>
								if (C = '1') then	nQ <= S3;
								else	nQ <= S5;
								end if;
							when "01" =>
								if (Z = '1') then	nQ <= S3;
								else nQ <= S5;
								end if;
							when "11" => 
								nQ <= S17;
						end case;
					when "0101" =>
							nQ <= S7;
					when "0111" => 
						nQ <= S7;
					when "1101" => 
						nQ <= S10;
					when "1100" => 
						nQ <= S12;
					when "1000" =>
						if (eq = '1') then nQ <= S14;
						else	nQ <= S5;
						end if;
					when others =>	
						nQ <= S5;
				end case;
			when S3 =>	
				nQ <= S4;
			when S4 =>
				if op_code = "0001" and condition = "11" then nQ <= S5; 
				else
					if(B = '0') then nQ <= S5;
					else nQ <= S1;
					end if;
				end if;
			when S5 =>	nQ <= S1;
			when S6 =>	
				if(B = '0') then nQ <= S5;
				else nQ <= S1;
				end if;
			when S7 =>
				if (op_code = "0000") then nQ <= S4;
				elsif (op_code = "0101") then nQ <= S8;
				elsif (op_code = "0111") then nQ <= S9;
				end if;
			when S8 => 
				nQ <= S5;
			when S9 =>
				nQ <= S1;
			when S10 => 
				nQ <= S11;
			when S11 =>
				if (invalid_next = '1') then nQ <= S5;
				else nQ <= S10;
				end if;
			when S12 =>	
				nQ <= S13;
			when S13 =>
				if (invalid_next = '1') then
					if(B = '0') then nQ <= S5;
					else nQ <= S1;
					end if;
				else nQ <= S12;
				end if;
			when S14 =>	
				nQ <= S5;
			when S15 => 
				if(B = '0') then nQ <= S5;
				else nQ <= S1;
				end if;
			when S16 =>
				if(B = '0') then nQ <= S5;
				else nQ <= S1;
				end if;
			when S17 => 
				nQ <= S18;
			when S18 => 
				nQ <= S4;
			when S19 =>
				if(B = '0') then nQ <= S5;
				else nQ <= S1;
				end if;
			when others =>	
				nQ <= S5;
		end case;
		if ((reset = '1') and (bootload = '1')) then
			nQ <= B0;
		elsif (reset = '1') then
			nQ <= S0;
		end if;
	end process;
		
end architecture;
