library IEEE;
use IEEE.std_logic_1164.all;

entity getZero is

  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
	   i_B  : in std_logic_vector(N-1 downto 0);
       o_F : out std_logic_vector(N-1 downto 0));

end getZero;

architecture dataflow of getZero is
begin

	gen: for i in 0 to N-1 generate
		o_F(i) <= i_A(i) and i_B(i);
	end generate;
  
  
end dataflow;