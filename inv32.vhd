library IEEE;
use IEEE.std_logic_1164.all;

entity invg32 is

  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F : out std_logic_vector(N-1 downto 0));

end invg32;

architecture dataflow of invg32 is
begin
	gen: for i in 0 to 31 generate
		o_F(i) <= not i_A(i);
	end generate;
  
end dataflow;
