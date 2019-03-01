library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fulladderNbit is
  generic(N : integer := 32);
  port(i_Cin        : in std_logic;
       i_A	    : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       o_Sum	    : out std_logic_vector(N-1 downto 0);
       overflow     : out std_logic;
       zero 	    : out std_logic;
       o_Cout	    : out std_logic);
end fulladderNbit;

architecture structure of fulladderNbit is

component fulladder
  port(i_Cin        : in std_logic;
       i_A	    : in std_logic;
       i_B	    : in std_logic;
       o_Sum	    : out std_logic;
       o_Cout       : out std_logic);
end component;

signal sC           : std_logic_vector(N downto 0);
signal sum	    : std_logic_vector(N-1 downto 0);
signal orSum        : std_logic_vector(N downto 0);

begin
  -- carry in for first case (LSb of sC)
  sC(0) <= i_Cin; 
-- generate 32 full adder instances and connect previous carry out to next carry in
G1: for i in 0 to N-1 generate
  fa_i: fulladder port map(sC(i), i_A(i), i_B(i), sum(i), sC(i+1));
end generate;
-- handles carryout
  o_Cout <= sC(N);
  overflow <= sC(N) XOR sC(N-1);
--base case:
  orSum(0) <= '0';
-- loop to OR all bits of o_Sum
G2: for i in 1 to N generate
  orSum(i) <= sum(i-1) OR orSum(i-1);
end generate;
  zero <= NOT orSum(N);
  o_Sum <= sum;
end structure;