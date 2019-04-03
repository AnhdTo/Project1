library IEEE;
use IEEE.std_logic_1164.all;

entity complimentor1_structural is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F1 : out std_logic_vector(N-1 downto 0));
	   
end complimentor1_structural;

architecture structure of complimentor1_structural is

component invg
  port(i_A  : in std_logic;
       o_F : out std_logic);
end component;

begin

-- We loop through and instantiate and connect N andg2 modules
G1: for i in 0 to N-1 generate
  invg_i: invg 
    port map(i_A  => i_A(i),
  	          o_F  => o_F1(i));
end generate;

  
end structure;
