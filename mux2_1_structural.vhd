library IEEE;
use IEEE.std_logic_1164.all;

entity mux2_1_structural is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_S  : in std_logic; -- s=1: choose i_A, 0: choose i_B
       o_F : out std_logic_vector(N-1 downto 0));
	   
end mux2_1_structural;

architecture structure of mux2_1_structural is

component invg
  port(i_A  : in std_logic;
       o_F : out std_logic);
end component;

component andg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

-- Signal to carry -s
signal s_S2         : std_logic;
-- Signal to carry i_A and i_S
signal s_X          : std_logic_vector(N-1 downto 0);
-- Signal to carry i_B and s_S2
signal s_Y          : std_logic_vector(N-1 downto 0);

begin

invg_1: invg 
	port map(i_A  => i_S,
		o_F  => s_S2);

-- We loop through and instantiate and connect N andg2 modules
G1: for i in 0 to N-1 generate
	andg_1: andg2
		port map(i_A => i_A(i),
		         i_B => i_S,
				 o_F => s_X(i));
				 
	andg_2: andg2
		port map(i_A => i_B(i),
				 i_B => s_S2,
				 o_F => s_Y(i));
				 
	org_1: org2
		port map(i_A => s_X(i),
				 i_B => s_Y(i),
				 o_F => o_F(i));
end generate;

  
end structure;
