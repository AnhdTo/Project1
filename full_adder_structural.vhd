library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_structural is
  generic(N : integer := 32);
  port(i_X  : in std_logic_vector(N-1 downto 0);
       i_Y  : in std_logic_vector(N-1 downto 0);
       i_C  : in std_logic;  -- carry bit
	   o_C  : out std_logic;  -- carry out bit
       o_F  : out std_logic_vector(N-1 downto 0));
	   
end full_adder_structural;

architecture structure of full_adder_structural is

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

component xorg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

-- Signal to carry Ci+1
signal s_C          : std_logic_vector(N-1 downto 0);
-- Signal to carry Xi xor Yi
signal s_A          : std_logic_vector(N-1 downto 0);
-- Signal to carry Xi and Yi
signal s_B          : std_logic_vector(N-1 downto 0);
-- Signal to carry s_A and Ci
signal s_D          : std_logic_vector(N-1 downto 0);

begin

xorg_2: xorg2
	port map(i_A => i_X(0),
		 i_B => i_Y(0),
		 o_F => s_A(0));

xorg_3: xorg2
	port map(i_A => s_A(0),
		 i_B => i_C,
		 o_F => o_F(0));

andg_2: andg2
	port map(i_A => i_X(0),
	         i_B => i_Y(0),
		 o_F => s_B(0));
			 
andg_3: andg2
	port map(i_A => s_A(0),
		 i_B => i_C,
		 o_F => s_D(0));
			 
org_1: org2
	port map(i_A => s_B(0),
		 i_B => s_D(0),
		 o_F => s_C(0));


G1: for i in 1 to N-1 generate

	xorg_2: xorg2
		port map(i_A => i_X(i),
			 i_B => i_Y(i),
			 o_F => s_A(i));

	xorg_3: xorg2
		port map(i_A => s_A(i),
			 i_B => s_C(i-1),
			 o_F => o_F(i));

	andg_2: andg2
		port map(i_A => i_X(i),
		         i_B => i_Y(i),
			 o_F => s_B(i));
				 
	andg_3: andg2
		port map(i_A => s_A(i),
			 i_B => s_C(i-1),
			 o_F => s_D(i));
				 
	org_1: org2
		port map(i_A => s_B(i),
			 i_B => s_D(i),
			 o_F => s_C(i));

end generate;

o_C <= s_C(N-1);

end structure;
