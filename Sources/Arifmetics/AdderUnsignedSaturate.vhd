LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

ENTITY AdderUnsignedSaturate is
	GENERIC(
		BITNS : natural;
		SUB : boolean
		);
	PORT(
	    A : IN STD_LOGIC_VECTOR(BITNS-1 downto 0);
		B : IN STD_LOGIC_VECTOR(BITNS-1 downto 0);
		RESULT : OUT STD_LOGIC_VECTOR(BITNS-1 downto 0)
		);
END ENTITY AdderUnsignedSaturate;

ARCHITECTURE RTL OF AdderUnsignedSaturate IS
BEGIN

g0 : if not sub generate
	process(A,B)
	variable output : unsigned(BITNS-1 downto 0);
	variable tmp_add : unsigned(BITNS downto 0);
	begin
	output := (others => '0');
	tmp_add := resize(unsigned(A), BITNS+1) + resize(unsigned(B), BITNS+1);
	if tmp_add(BITNS) /= tmp_add(BITNS-1) then
		output(BITNS-1 downto 0) := (others => tmp_add(BITNS));
	else
		output := tmp_add(BITNS-1 downto 0);
	end if;
	RESULT <= std_logic_vector(output);
	end process;
end generate;

g1 : if sub generate
	process(A,B)
		variable output : unsigned(BITNS-1 downto 0);
		variable tmp_sub : unsigned(BITNS downto 0);
		begin
		output := (others => '0');
		tmp_sub := resize(unsigned(A), BITNS+1) - resize(unsigned(B), BITNS+1);
		if tmp_sub(BITNS) = '1' then
			output(BITNS-1 downto 0) := (others => not tmp_sub(BITNS));
		else
			output := tmp_sub(BITNS-1 downto 0);
		end if;
		RESULT <= std_logic_vector(output);
		end process;
end generate;

END ARCHITECTURE RTL;