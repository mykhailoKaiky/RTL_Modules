library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_AdderSignedSaturate is
end test_AdderSignedSaturate;

architecture RTL of test_AdderSignedSaturate is

constant BITNS : natural := 16;

component AdderSignedSaturate
	GENERIC(
		BITNS : natural;
		SUB : boolean
		);
	PORT(
	    A : IN STD_LOGIC_VECTOR(BITNS-1 downto 0);
		B : IN STD_LOGIC_VECTOR(BITNS-1 downto 0);
		RESULT : OUT STD_LOGIC_VECTOR(BITNS-1 downto 0)
		);
end component;

signal A : std_logic_vector(BITNS-1 downto 0);
signal B : std_logic_vector(BITNS-1 downto 0);
signal RES_ADD : std_logic_vector(BITNS-1 downto 0);
signal RES_SUB : std_logic_vector(BITNS-1 downto 0);

begin

module_adder: AdderSignedSaturate Generic Map(BITNS => BITNS, SUB => FALSE) Port Map(A => A, B => B, RESULT => RES_ADD);
module_sub: AdderSignedSaturate Generic Map(BITNS => BITNS, SUB => TRUE) Port Map(A => A, B => B, RESULT => RES_SUB);

uut: process
begin
A <= std_logic_vector(TO_SIGNED(0,BITNS));
B <= std_logic_vector(TO_SIGNED(1,BITNS));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(1,BITNS));
B <= std_logic_vector(TO_SIGNED(0,BITNS));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(-1,BITNS));
B <= std_logic_vector(TO_SIGNED(0,BITNS));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(-1,BITNS));
B <= std_logic_vector(TO_SIGNED(-1,BITNS));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(1,BITNS));
B <= std_logic_vector(TO_SIGNED(1,BITNS));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(32767,BITNS));
B <= std_logic_vector(TO_SIGNED(1,BITNS));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(-32767,BITNS));
B <= std_logic_vector(TO_SIGNED(-1,BITNS));
wait for 5 ns;
A <= std_logic_vector(TO_SIGNED(-32768,BITNS));
B <= std_logic_vector(TO_SIGNED(-1,BITNS));
wait for 5 ns;
wait;
end process;

end RTL;