library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity test_LFSR is
end test_LFSR;

architecture Behavioral of test_LFSR is

-- Constants -- 
constant OUTPUT_WIDTH : natural := 31;
constant clk_period : time := 10 ns;

constant outputfilename : string := "LFSR_output.txt";

component LFSR
	Generic(
		OUTPUT_WIDTH : natural
	);
	PORT( 
		clk : in std_logic;
		reset : in std_logic;
		seed : in std_logic_vector(30 downto 0);
		output : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)
	);
end component;

-- Open Files -- 
file output_file : TEXT open write_mode  is outputfilename;

-- End open files -- 

-- Signals --
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal output : std_logic_vector(OUTPUT_WIDTH-1 downto 0);

begin

module_LFSR: LFSR
Generic Map(OUTPUT_WIDTH => OUTPUT_WIDTH)
Port Map(clk => clk, reset => reset,seed => "1111111111111111000000000000000", output => output);

clk_process: process
begin
clk <= '0';
wait for 10 ns;
clk <= '1';
wait for 10 ns;
end process;

file_write: process(clk)
variable l : line;
begin
if rising_edge(clk) then
    write(l,to_integer(unsigned(output)));
    writeline(output_file,l);
end if;
end process;

uut: process
begin
reset <= '0';
wait for 20 ns;
reset <= '1';
wait for clk_period*2;
reset <= '0';
wait;
end process;

end Behavioral;
