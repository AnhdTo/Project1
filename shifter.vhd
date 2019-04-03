library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
  port(
	   i_In  : in std_logic_vector(31 downto 0);
	   i_S   : in std_logic;  -- arithmetic 1 vs logical 0
	   i_RorL: in std_logic;  -- right 1 vs left 0
	   i_shamt : in std_logic_vector(4 downto 0);
	   o_Out : out std_logic_vector(31 downto 0));
end shifter;

architecture structure of shifter is

component mux2_1_structural
  port(i_A  : in std_logic_vector(31 downto 0);
       i_B  : in std_logic_vector(31 downto 0);
       i_S  : in std_logic;
       o_F : out std_logic_vector(31 downto 0));
end component;

-- Signal to highest bit of in_In
signal s_A          : std_logic;
-- Signal to carry result after 1 bit right shift
signal s_B          : std_logic_vector(31 downto 0);
-- Signal to carry result after 2 bit right shift
signal s_C          : std_logic_vector(31 downto 0);
-- Signal to carry result after 4 bit right shift
signal s_D          : std_logic_vector(31 downto 0);
-- Signal to carry result after 8 bit right shift
signal s_E          : std_logic_vector(31 downto 0);
-- Signal to carry result after 16 bit right shift
signal s_Right      : std_logic_vector(31 downto 0);
-- Signal to carry result after 16 bit left shift
signal s_Left       : std_logic_vector(31 downto 0);
-- temporary signals
signal s_In, a       : std_logic_vector(31 downto 0);
-- Signal to carry shift values
signal s_B1, s_C1, s_D1, s_E1, s_F1 : std_logic_vector(31 downto 0);

begin

	gen: for i in 0 to 31 generate
		a(i) <= i_In(31-i);
	end generate;

	s_In <= i_In when (i_RorL='1') else a;
	
	s_A <= s_In(31) when (i_s='1' and i_RorL='1') else
		   '0';
		   
	s_B1 <= s_A & s_In(31 downto 1);
	
	mux2_1_structural_1: mux2_1_structural
		port map(
			i_A => s_B1,
			i_B => s_In,
			i_S => i_shamt(0),
			o_F => s_B);
			
	s_C1 <= s_A & s_A & s_B(31 downto 2);
			
	mux2_1_structural_2: mux2_1_structural
		port map(
			i_A => s_C1,
			i_B => s_B,
			i_S => i_shamt(1),
			o_F => s_C);
			
	s_D1 <= s_A & s_A & s_A & s_A & s_C(31 downto 4);
			
	mux2_1_structural_3: mux2_1_structural
		port map(
			i_A => s_D1,
			i_B => s_C,
			i_S => i_shamt(2),
			o_F => s_D);
			
	s_E1 <= s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_D(31 downto 8);
			
	mux2_1_structural_4: mux2_1_structural
		port map(
			i_A => s_E1,
			i_B => s_D,
			i_S => i_shamt(3),
			o_F => s_E);
			
	s_F1 <= s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_A & s_E(31 downto 16);
			
	mux2_1_structural_5: mux2_1_structural
		port map(
			i_A => s_F1,
			i_B => s_E,
			i_S => i_shamt(4),
			o_F => s_Right);

	gen1: for i in 0 to 31 generate
		s_Left(i) <= s_Right(31-i);
	end generate;
	o_Out <= s_Right when (i_RorL='1') else s_Left;
	
end structure;
