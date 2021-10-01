--============================================================================--
-- File name : test_debounce.vhd
--
-- Library : Work
--
-- Author : Kaiky Mykhailo
-- Belarusian State University of Informatics ans Radioelectronics
-- email: kaikymykhailo@gmail.com
--
-- Simulator : modelsim 10.6b, Vivado 2019.2
--============================================================================--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_debounce is
end test_debounce;

architecture Behav of test_debounce is

constant clk_period : time := 10 ns;

component debounce
  Generic(
    clk_freq    : INTEGER := 100_000_000;	--system clock frequency in Hz
    stable_time : INTEGER := 1				--time button must remain stable in ms
	);
  Port(
    clk     	: in  std_logic;
    reset_async : in  std_logic;
    button  	: in  std_logic;
    result  	: out std_logic
	); 
end component;

signal clk, reset_async, button, result : std_logic;

begin

debounce_module: debounce
Generic Map(
			clk_freq => 100_000_000,
			stable_time => 1
			)
Port Map(
			clk => clk,
			reset_async => reset_async,
			button => button,
			result => result
			);

clock_proc: process
begin
clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;
end process;

uut: process
begin
reset_async <= '1';
button <= '0';
wait for 50 ns;
reset_async <= '0';
wait for 100 ns;
reset_async <= '1';
wait for 200 ns;
button <= '1';
wait for 4000 ns;
button <= '0';
wait for 1500 ns;
button <= '1';
wait for 2000 ns;
button <= '0';
wait for 1200 ns;
button <= '1';
wait for 1400000 ns;
button <= '0';
wait;
end process;

end Behav;