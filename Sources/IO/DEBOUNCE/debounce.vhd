--============================================================================--
-- File name : debounce.vhd
--
-- Library : Work
--
-- Author : Kaiky Mykhailo
-- Belarusian State University of Informatics ans Radioelectronics
-- email: kaikymykhailo@gmail.com
--
-- Simulator : modelsim 10.6b, Vivado 2019.2
--============================================================================--
library ieee;
use ieee.std_logic_1164.all;

entity debounce is
  Generic(
    clk_freq    : INTEGER;		--system clock frequency in Hz
    stable_time : INTEGER		--time button must remain stable in ms
	);
  Port(
    clk     	: in  std_logic;
    reset_async : in  std_logic;
    button  	: in  std_logic;
    result  	: out std_logic
	); 
end debounce;

architecture RTL of debounce is
  signal flipflops   : std_logic_vector(1 downto 0); --input flip flops
  signal counter_set : std_logic;                    --sync reset to zero
begin
  counter_set <= flipflops(0) xor flipflops(1);  --determine when to start/reset counter
  
  process(clk, reset_async)
  variable count :  integer range 0 to (clk_freq*stable_time/1000);  --counter for timing
  begin
    if reset_async = '0' then                        --reset
      flipflops(1 downto 0) <= (others => '0');
      result <= '0';    
    elsif rising_edge(clk) then
      flipflops(0) <= button;
      flipflops(1) <= flipflops(0);
      if(counter_set = '1') then
        count := 0;
      elsif(count < clk_freq*stable_time/1000) then
        count := count + 1;
      else
        result <= flipflops(1);
      end if;    
    end if;
  end process;
  
end RTL;
