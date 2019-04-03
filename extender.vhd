library IEEE;
use IEEE.std_logic_1164.all;

entity extender is
	port(
	  i_s     : in std_logic;
	  i_16    : in std_logic_vector(15 downto 0);
	  o_32    : out std_logic_vector(31 downto 0));
end extender;

architecture dataflow of extender is
	signal s_Sign, s_Zero : std_logic_vector(31 downto 0);
	
	begin
	  s_Sign <= X"0000" & i_16 when (i_16(15)='0') else
			X"FFFF" & i_16;
	  s_Zero <= X"0000" & i_16;
	  o_32 <= s_Sign when (i_s='1') else
		   s_Zero;
		   
end dataflow;