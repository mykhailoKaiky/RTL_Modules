--============================================================================--
-- File name : AdderUnsignedSaturate.vhd
--
-- Purpose : Adder Unsigned Saturate Module
--
-- Errors: : None known
--
-- Library : Work
--
-- Author : Kaiky Mykhailo
-- Belarusian State University of Informatics ans Radioelectronics
-- email: kaikymykhailo@gmail.com
--
-- Simulator : ModelSim 10.6b
---------------------------------------------------
-- Revision list
-- Version Author Date Changes
-- 1.0 27.08.2021 - Done
--============================================================================--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

ENTITY AdderSignedSaturate is
	GENERIC(
		BITNS : natural;
		SUB : boolean
		);
	PORT(
	    A : IN STD_LOGIC_VECTOR(BITNS-1 downto 0);
		B : IN STD_LOGIC_VECTOR(BITNS-1 downto 0);
		RESULT : OUT STD_LOGIC_VECTOR(BITNS-1 downto 0)
		);
END ENTITY AdderSignedSaturate;

ARCHITECTURE RTL OF AdderSignedSaturate IS
BEGIN

g0 : if not sub generate
	process(A,B)
	variable output : signed(BITNS-1 downto 0);
	variable tmp_add : signed(BITNS downto 0);
	begin
	output := (others => '0');
	tmp_add := resize(signed(A), BITNS+1) + resize(signed(B), BITNS+1);
	if tmp_add(BITNS) /= tmp_add(BITNS-1) then
		output(BITNS-1) := tmp_add(BITNS);
		output(BITNS-2 downto 0) := (others => tmp_add(BITNS-1));
	else
		output := tmp_add(BITNS-1 downto 0);
	end if;
	RESULT <= std_logic_vector(output);
	end process;
end generate;

g1 : if sub generate
	process(A,B)
		variable output : signed(BITNS-1 downto 0);
		variable tmp_sub : signed(BITNS downto 0);
		begin
		output := (others => '0');
		tmp_sub := resize(signed(A), BITNS+1) - resize(signed(B), BITNS+1);
		if tmp_sub(BITNS) /= tmp_sub(BITNS-1) then
			output(BITNS-1) := tmp_sub(BITNS);
			output(BITNS-2 downto 0) := (others => tmp_sub(BITNS-1));
		else
			output := tmp_sub(BITNS-1 downto 0);
		end if;
		RESULT <= std_logic_vector(output);
		end process;
end generate;

END ARCHITECTURE RTL;