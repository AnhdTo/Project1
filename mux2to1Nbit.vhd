library IEEE;
use IEEE.std_logic_1164.all;

entity mux2to1Nbit is
  generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       i_X	    : in std_logic;
       o_Y          : out std_logic_vector(N-1 downto 0));

end mux2to1Nbit;

architecture structure of mux2to1Nbit is
component inv
  port(input          : in std_logic;
       output          : out std_logic);
end component;

component or2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component and2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

signal s1, s2, s3   : std_logic_vector(N-1 downto 0);

begin
G1: for i in 0 to N-1 generate
  inversion_i: inv 
    port map(i_X, s1(i));
  and1_i: and2
    port map(i_A(i), s1(i), s2(i));
  and2_i: and2
    port map(i_X, i_B(i), s3(i));
  or2_i: or2
    port map(s2(i), s3(i), o_Y(i));
end generate;

end structure;
