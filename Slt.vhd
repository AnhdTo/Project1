library IEEE;
use IEEE.std_logic_1164.all;
entity Slt is
  generic(N : integer := 32);
  port(A	    : in std_logic_vector(N-1 downto 0);
       B	    : in std_logic_vector(N-1 downto 0);
       Result	    : out std_logic_vector(N-1 downto 0));
end entity Slt;
architecture dataflow of Slt is

signal s_slt1    : std_logic_vector(31 downto 0) :=x"00000001";
signal s_slt2    : std_logic_vector(31 downto 0):=x"00000000";
begin
Result <= s_slt1 when (A <B) else
		  s_slt2;
  
end dataflow;