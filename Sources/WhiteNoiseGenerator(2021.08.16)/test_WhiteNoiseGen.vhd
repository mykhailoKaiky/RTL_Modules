library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity test_WhiteNoiseGen is
end test_WhiteNoiseGen;

architecture Behavioral of test_WhiteNoiseGen is

-- Constants -- 
constant N : natural := 16;
constant OUTPUT_WIDTH : natural := 16;
constant clk_period : time := 10 ns;
constant outputfilename : string := "WhiteNoiseGen_output.txt";

component WhiteNoiseGen
Generic(
	N : natural;
    OUTPUT_WIDTH_NOISE : natural
);
PORT( 
    clk : in std_logic;
    reset : in std_logic;
    output : out std_logic_vector(N-1 downto 0)
);
end component;

-- Open Files -- 
file output_file : TEXT open write_mode  is outputfilename;

-- End open files -- 

-- Signals --
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal output : std_logic_vector(N-1 downto 0);

begin

module_WhiteNoiseGen: WhiteNoiseGen
Generic Map(N=>N,OUTPUT_WIDTH_NOISE => OUTPUT_WIDTH)
Port Map(clk => clk, reset => reset, output => output);

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
    write(l,to_integer(signed(output)));
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
