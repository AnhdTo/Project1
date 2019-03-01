library IEEE;
use IEEE.std_logic_1164.all;

entity mux2to1 is
  port(i_A          : in std_logic;
       i_B	    : in std_logic;
       i_X	    : in std_logic;
       o_Y          : out std_logic);

end mux2to1;

architecture structure of mux2to1 is
component inv
  port(input          : in std_logic;
       output          : out std_logic);
end component;

component or2
  port(i_A        : in std_logic;
       i_B        : in std_logic;
       o_F         : out std_logic);
end component;

component and2
  port(i_A       : in std_logic;
       i_B       : in std_logic;
       o_F        : out std_logic);
end component;

signal s1, s2, s3   : std_logic;

begin
  inversion_1: inv 
    port map(i_X, s1);
  and2_1: and2
    port map(i_A, s1, s2);
  and2_2: and2
    port map(i_X, i_B, s3);
  or_1: or2
    port map(s2, s3, o_Y);

end structure;
