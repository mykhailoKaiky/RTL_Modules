library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_MUL_NxN_SIGNED is
end test_MUL_NxN_SIGNED;

architecture RTL of test_MUL_NxN_SIGNED is

constant N : natural := 16;
constant SH : natural := 0;
constant OWL : natural := 16;

component MUL_NxN_SIGNED
    Generic(
	N:natural;
	SH : natural;
	OWL : natural
	);
    Port(
	A : in  STD_LOGIC_VECTOR (N-1 downto 0);
    B : in  STD_LOGIC_VECTOR (N-1 downto 0);
	RESULT : out STD_LOGIC_VECTOR(OWL-1 downto 0)
	);
end component;

signal A : std_logic_vector(N-1 downto 0);
signal B : std_logic_vector(N-1 downto 0);
signal RESULT : std_logic_vector(OWL-1 downto 0);

begin
module_mult: MUL_NxN_SIGNED Generic Map(N=> N, SH => SH, OWL => OWL) Port Map(A => A, B => B, RESULT => RESULT);

uut: process
begin
A <= std_logic_vector(TO_SIGNED(0,N));
B <= std_logic_vector(TO_SIGNED(1,N));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(1,N));
B <= std_logic_vector(TO_SIGNED(0,N));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(1,N));
B <= std_logic_vector(TO_SIGNED(1,N));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(0,N));
B <= std_logic_vector(TO_SIGNED(0,N));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(-32768,N));
B <= std_logic_vector(TO_SIGNED(-32768,N));
wait;
end process;

end RTL;