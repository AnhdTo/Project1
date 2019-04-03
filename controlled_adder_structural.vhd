library IEEE;
use IEEE.std_logic_1164.all;

entity controlled_adder_structural is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_C  : in std_logic;  --nAdd_Sub 0: add, 1: sub
	   i_D  : in std_logic;  --ALUSrc 0: rt(i_B), 1: imm
	   i_Im : in std_logic_vector(N-1 downto 0);    --immediate integer
	   o_C  : out std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));
	   
end controlled_adder_structural;

architecture structure of controlled_adder_structural is

component full_adder_structural
  port(i_X : in std_logic_vector(31 downto 0);
       i_Y : in std_logic_vector(31 downto 0);
       i_C : in std_logic;
	   o_C  : out std_logic;
       o_F : out std_logic_vector(31 downto 0));
end component;

component mux2_1_structural
  port(i_A : in std_logic_vector(31 downto 0);
       i_B : in std_logic_vector(31 downto 0);
       i_S : in std_logic;
       o_F : out std_logic_vector(31 downto 0));
end component;

component complimentor1_structural
  port(i_A : in std_logic_vector(31 downto 0);
       o_F1 : out std_logic_vector(31 downto 0));
end component;

-- Signal to carry mux2_1_nAdd_Sub
signal s_A          : std_logic_vector(N-1 downto 0);
-- Signal to carry negate B
signal s_B          : std_logic_vector(N-1 downto 0);
-- Signal to carry mux2_1_ALUSrc
signal s_C          : std_logic_vector(N-1 downto 0);

begin

-- We loop through and instantiate and connect N andg2 modules
			 
	mux2_1_ALUSrc: mux2_1_structural
		port map(i_A => i_Im,
			 i_B => i_B,
			 i_S => i_D,
			 o_F => s_A);
			 
	complimentor1_structural_1: complimentor1_structural
		port map(i_A  => s_A,
			 o_F1 => s_B);

	mux2_1_nAdd_Sub: mux2_1_structural
		port map(i_A => s_B,
			 i_B => s_A,
			 i_S => i_C,
			 o_F => s_C);

	full_adder_structural_1: full_adder_structural
		port map(i_X => i_A,
			 i_Y => s_C,
			 i_C => i_C,
			 o_C => o_C,
			 o_F => o_F);
			 
end structure;
