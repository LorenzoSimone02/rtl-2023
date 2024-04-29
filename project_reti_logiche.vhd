----------------------------------------------------------------------------
-- Company: Politecnico di Milano
-- Engineer: Lorenzo Simone
--
-- Project Name: Progetto di Reti Logiche
-----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;

entity project_reti_logiche is
	port (
		i_clk      : in std_logic;
		i_rst      : in std_logic;
		i_start    : in std_logic;
		i_add      : in std_logic_vector(15 downto 0);
		i_k        : in std_logic_vector(9 downto 0);
 
		o_done     : out std_logic;
 
		o_mem_addr : out std_logic_vector(15 downto 0);
		i_mem_data : in std_logic_vector(7 downto 0);
		o_mem_data : out std_logic_vector(7 downto 0);
		o_mem_we   : out std_logic;
		o_mem_en   : out std_logic
	);
end project_reti_logiche;

architecture behavioral of project_reti_logiche is
	type STATE is (IDLE, START, CHECK, READ, WRITE, STORE, DONE);
 
	signal current_state, next_state : STATE;
	signal data, next_data           : std_logic_vector(7 downto 0);
	signal cred, next_cred           : std_logic_vector(4 downto 0);
	signal offset, next_offset       : integer;
 
begin
	process (i_clk, i_rst)
	begin
		if i_rst = '1' then 
			current_state <= IDLE;
		elsif rising_edge(i_clk) then
			cred <= next_cred;
			offset <= next_offset;
			data <= next_data;
			current_state <= next_state;
		end if;
	end process;
 
	process (current_state, i_start, i_mem_data, i_add, i_k, cred, offset, data)
		begin
			o_done <= '0';
			next_cred <= cred;
			next_offset <= offset;
			next_data <= data;
			o_mem_addr <= i_add + offset;
 
			case current_state is
				when IDLE => 
					o_mem_en <= '0';
					o_mem_we <= '0';
					o_mem_data <= "00000000";
 
					if (i_start = '0') then
						next_state <= IDLE;
					else
						next_state <= START;
					end if;
				-----------------------------------------------------
				when START => 
					o_mem_en <= '1';
					o_mem_we <= '0';
 
					next_cred <= "00000";
					next_data <= "00000000";
					o_mem_data <= "00000000";
					next_offset <= 0;
 
					next_state <= CHECK;
				----------------------------------------------------- 
				when CHECK => 
					o_mem_en <= '1';
					o_mem_we <= '0';
					o_mem_data <= "00000000";
 
					if (offset >= (unsigned(i_k) * 2)) then
						next_state <= DONE;
					else
						next_state <= READ; 
					end if;
				----------------------------------------------------- 
				when READ => 
					o_mem_en <= '1';
					o_mem_we <= '0';
					o_mem_data <= "00000000";
 
					if (i_mem_data > 0) then
						next_data <= i_mem_data; 
						next_cred <= "11111";
					end if; 
 
					next_state <= STORE; 
				----------------------------------------------------- 
				when STORE => 
					o_mem_en <= '1';
					o_mem_we <= '1';
 
					o_mem_data <= data;
 
					next_offset <= offset + 1; 
					next_state <= WRITE; 
				----------------------------------------------------- 
				when WRITE => 
					o_mem_en <= '1';
					o_mem_we <= '1';
 
					o_mem_data <= "000" & cred; 
					if (cred > 0) then
						next_cred <= cred - 1;
					end if;
					next_offset <= offset + 1; 
 
					next_state <= CHECK; 
				----------------------------------------------------- 
				when DONE => 
					o_mem_en <= '0';
					o_mem_we <= '0';
					o_mem_data <= "00000000";
					if (i_start = '0') then
						next_state <= IDLE;
					else
						o_done <= '1';
						next_state <= DONE;
					end if;
			end case;
		end process;
end behavioral;
