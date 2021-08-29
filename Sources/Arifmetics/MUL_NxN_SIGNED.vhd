library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

entity MUL_NxN_SIGNED is
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
end MUL_NxN_SIGNED;

architecture Behavioral of MUL_NxN_SIGNED is
CONSTANT temp_size : natural := 2*N;
begin

mult: PROCESS(A, B)
  VARIABLE G_mul: signed(temp_size-1 downto 0);
  BEGIN
    G_mul := signed(A) * signed(B);	
    RESULT <= std_logic_vector(G_mul(temp_size-1-SH downto temp_size-OWL-SH));
  END PROCESS mult;

end Behavioral;

