library IEEE;
use IEEE.std_logic_1164.all;

entity add_sub is
  generic(N : integer := 32);
  port(A	    : in std_logic_vector(N-1 downto 0);
       B	    : in std_logic_vector(N-1 downto 0);
       nAdd_Sub	    : in std_logic;
       Overflow     : out std_logic;
       Zero	    : out std_logic;
       Carry	    : out std_logic;
       Result	    : out std_logic_vector(N-1 downto 0));
end add_sub;

architecture structure of add_sub is

component fulladderNbit is
  generic(N : integer := 32);
  port(i_Cin        : in std_logic;
       i_A	    : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       o_Sum	    : out std_logic_vector(N-1 downto 0);
       overflow     : out std_logic;
       zero 	    : out std_logic;
       o_Cout	    : out std_logic);
end component;

component ones_comp_d is
  generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
end component;

component mux2to1Nbit is
  generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       i_X	    : in std_logic;
       o_Y          : out std_logic_vector(N-1 downto 0));
end component;

signal sMux, sInvB     : std_logic_vector(N-1 downto 0);

begin 
  fa: fulladderNbit port map(nAdd_Sub, A, sMux, Result, Overflow, Zero, Carry);
  inv1: ones_comp_d port map(B, sInvB);
  mux2: mux2to1Nbit port map(B, sInvB, nAdd_Sub, sMux);

end structure;