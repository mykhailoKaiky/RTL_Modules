library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity WhiteNoiseGen is
	Generic(
		N : natural;
		OUTPUT_WIDTH_NOISE : natural
	);
	PORT( 
		clk : in std_logic;
		reset : in std_logic;
		output : out std_logic_vector(N-1 downto 0)
	);
end WhiteNoiseGen;

architecture Behavioral of WhiteNoiseGen is

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

signal LFSR_0 : std_logic_vector(OUTPUT_WIDTH_NOISE-3 downto 0);
signal LFSR_1 : std_logic_vector(OUTPUT_WIDTH_NOISE-3 downto 0);
signal LFSR_2 : std_logic_vector(OUTPUT_WIDTH_NOISE-3 downto 0);
signal LFSR_3 : std_logic_vector(OUTPUT_WIDTH_NOISE-3 downto 0);
constant seed_0 : std_logic_vector(30 downto 0) := "1010010001110001111111010100100";
constant seed_1 : std_logic_vector(30 downto 0) := "0101001000101000101001010011010";
constant seed_2 : std_logic_vector(30 downto 0) := "0010101001010101010101010111010";
constant seed_3 : std_logic_vector(30 downto 0) := "0101010001010100100100000101010";
begin
LFSR_reg0: LFSR Generic Map(OUTPUT_WIDTH => OUTPUT_WIDTH_NOISE-2) Port Map(clk => clk, reset => reset, seed => seed_0, output => LFSR_0);
LFSR_reg1: LFSR Generic Map(OUTPUT_WIDTH => OUTPUT_WIDTH_NOISE-2) Port Map(clk => clk, reset => reset, seed => seed_1, output => LFSR_1);
LFSR_reg2: LFSR Generic Map(OUTPUT_WIDTH => OUTPUT_WIDTH_NOISE-2) Port Map(clk => clk, reset => reset, seed => seed_2, output => LFSR_2);
LFSR_reg3: LFSR Generic Map(OUTPUT_WIDTH => OUTPUT_WIDTH_NOISE-2) Port Map(clk => clk, reset => reset, seed => seed_3, output => LFSR_3);

adder: process(clk,reset)
variable tmp_output : std_logic_vector(OUTPUT_WIDTH_NOISE downto 0);
variable temp_output : std_logic_vector(OUTPUT_WIDTH_NOISE-1 downto 0);
variable bla : std_logic_vector(N-1 downto 0);
begin
if reset = '1' then
    output <= (others => '0');
elsif rising_edge(clk) then
tmp_output := std_logic_vector((resize(signed(LFSR_0),OUTPUT_WIDTH_NOISE+1) + resize(signed(LFSR_1),OUTPUT_WIDTH_NOISE+1)) + (resize(signed(LFSR_2),OUTPUT_WIDTH_NOISE+1) + resize(signed(LFSR_3),OUTPUT_WIDTH_NOISE+1)));
if tmp_output(OUTPUT_WIDTH_NOISE) /= tmp_output(OUTPUT_WIDTH_NOISE-1) then
    temp_output(OUTPUT_WIDTH_NOISE-1) := tmp_output(OUTPUT_WIDTH_NOISE);
    temp_output(OUTPUT_WIDTH_NOISE-2 downto 0) := (others => tmp_output(OUTPUT_WIDTH_NOISE-1));

else
    temp_output := tmp_output(OUTPUT_WIDTH_NOISE-1 downto 0);
end if;
    bla(N-1 downto OUTPUT_WIDTH_NOISE) := (others => '0');
    bla(OUTPUT_WIDTH_NOISE-1 downto 0) := temp_output;
    output <= bla;
end if;
end process;


end Behavioral;