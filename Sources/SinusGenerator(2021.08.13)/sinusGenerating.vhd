library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity sinusGenerating is
Generic(N : natural);
Port (
        clk : in std_logic;
        reset : in std_logic;
        sin_factor : in signed(N-1 downto 0);
        output_data : out std_logic_vector(N-1 downto 0)        
);
end sinusGenerating;

architecture Behavioral of sinusGenerating is
constant N_ROM_SIN : natural := 10;
constant ROM_LENGTH : natural := 1024;

-- Signals ROM Sinus --
signal ROM_sin_output_data : signed(N-1 downto 0);
-- End Signals ROM Sinus --

-- Signals Counter -- 
signal counter : unsigned(N_ROM_SIN-1 downto 0) := (others => '0');
signal flg_counter : std_logic := '0';
signal switch_invertor : std_logic := '1';
-- End Signals Counter -- 

-- Temporary Signals --
signal main_factor : signed(N-1 downto 0) := TO_SIGNED(32767,N);
signal prev_factor : signed(N-1 downto 0) := TO_SIGNED(32767,N);	
signal tmp : signed(3*N-1 downto 0);
signal tmp_counter_switch : std_logic := '0';
signal tmp_counter_delay : std_logic := '0';
-- End Temporary Signals --

component sinus_ROM is
Generic(length_ROM : natural; N_ROM_SIN : natural; N : natural);
Port ( 
        clk : in std_logic;
        reset : in std_logic;
        addr : in std_logic_vector(N_ROM_SIN-1 downto 0);
        output_ROM_data : out signed(N-1 downto 0)
);
end component;

begin

process(clk, reset)
begin
if reset = '1' then
	counter <= (others => '0');
	flg_counter <= '0';
	tmp <= (others => '0');
	main_factor <= TO_SIGNED(32767,N);
	prev_factor <= TO_SIGNED(32767,N);
	output_data <= (others => '0');
elsif rising_edge(clk) then
	if counter = TO_UNSIGNED(1, N_ROM_SIN) then
		flg_counter <= '0';
	elsif counter = TO_UNSIGNED(ROM_LENGTH-2,N_ROM_SIN) then
		flg_counter <= '1';
	end if;
	if flg_counter = '0' then
		counter <= counter + 1;
	else
		counter <= counter - 1;
	end if;
	if counter = TO_UNSIGNED(0, N_ROM_SIN) then
		tmp_counter_switch <= '1';
	end if;
	if tmp_counter_switch = '1' then
		switch_invertor <= not switch_invertor;
		tmp_counter_switch <= '0';
	else
		tmp_counter_delay <= '0';
	end if;
	if switch_invertor = '1' then
		tmp(3*N-1 downto 0) <= main_factor * ROM_sin_output_data * TO_SIGNED(-1,N);
	else
		tmp(2*N-1 downto 0) <= main_factor * ROM_sin_output_data;
	end if;
	prev_factor <= sin_factor;
	if main_factor /= prev_factor then
		if tmp(2*N-1 downto N) = TO_SIGNED(0, N) then
			main_factor <= prev_factor;
		end if;		
	end if;
	output_data <= std_logic_vector(tmp(2*N-1 downto N));
end if;
end process;

ROM_SIN: sinus_ROM Generic Map(length_ROM=>ROM_length,N_ROM_SIN => N_ROM_SIN, N=>N) Port Map(clk=>clk,reset=>reset,output_ROM_data=> ROM_sin_output_data, addr => std_logic_vector(counter));

end Behavioral;
