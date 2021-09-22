library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LFSR is
	Generic(
		OUTPUT_WIDTH : natural
	);
	PORT( 
		clk : in std_logic;
		reset : in std_logic;
		seed : in std_logic_vector(30 downto 0);
		output : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)
	);
end LFSR;

architecture Behavioral of LFSR is
constant N : natural := 31;
begin

process(clk,reset)
variable feedback : std_logic;
variable reg : std_logic_vector(N-1 downto 0);
variable tmp_reg : std_logic_vector(N-1 downto 0);
constant length_cycle : natural := 15;
begin
feedback := not((reg(0) xor reg(3)));
if reset = '1' then
	tmp_reg := seed;
	reg := seed;
elsif rising_edge(clk) then
--tmp_reg := reg;
for i in 0 to length_cycle-1 loop
    tmp_reg := feedback&tmp_reg(N-1 downto 1);
    feedback := not((tmp_reg(3) xor tmp_reg(0)));
end loop;
reg := tmp_reg;
output <= reg(OUTPUT_WIDTH-1 downto 0);
end if;
end process;

end Behavioral;