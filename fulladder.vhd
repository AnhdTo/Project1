library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder is
  port(i_Cin        : in std_logic;
       i_A	    : in std_logic;
       i_B	    : in std_logic;
       o_Sum	    : out std_logic;
       o_Cout       : out std_logic);
end fulladder;

architecture structure of fulladder is
component xor2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
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

signal s1, s2, s3, s4, s5   : std_logic;

begin
  xor2_1: xor2 
    port map(i_A, i_B, s1);
  xor2_2: xor2 
    port map(i_Cin, s1, o_Sum);
  and2_1:and2
    port map(i_A, i_B, s2);
  and2_2: and2
    port map(i_B, i_Cin, s3);
  and2_3: and2
    port map(i_A, i_Cin, s4);
  or2_1: or2
    port map(s2, s3, s5);
  or2_2: or2
    port map(s4, s5, o_Cout);

end structure;