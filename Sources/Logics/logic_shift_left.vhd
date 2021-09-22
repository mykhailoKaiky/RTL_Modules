--============================================================================--
-- File name : logic_shift_left.vhd
--
-- Purpose : 
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
--============================================================================--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_shift_left is
	Generic(
		N : natural
	);
	Port( 
	X : in std_logic_vector(N-1 downto 0);
	Z : out std_logic_vector(N-1 downto 0);
	C : out std_logic
	);
end logic_shift_left;

architecture Behavioral of logic_shift_left is
begin
C <= X(N-1);
Z <= X(N-2 downto 0) & '0';
end Behavioral;

