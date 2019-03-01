library IEEE;
use IEEE.std_logic_1164.all;

entity mux8to1 is
  generic(N : integer := 32);
  port(i_w0,i_w1,i_w2,i_w3      : in std_logic_vector(N-1 downto 0);
       i_w4,i_w5,i_w6,i_w7      : in std_logic_vector(N-1 downto 0);
       i_s0	    		: in std_logic;
       i_s1	    		: in std_logic;
       i_s2	    		: in std_logic;
       o_Y          		: out std_logic_vector(N-1 downto 0));
end mux8to1;

architecture structure of mux8to1 is

component mux4to1
generic(N : integer := 32);
  port(i_w0         : in std_logic_vector(N-1 downto 0);
       i_w1	    : in std_logic_vector(N-1 downto 0);
       i_w2         : in std_logic_vector(N-1 downto 0);
       i_w3	    : in std_logic_vector(N-1 downto 0);
       i_s0	    : in std_logic;
       i_s1	    : in std_logic;
       o_Y          : out std_logic_vector(N-1 downto 0));
end component;

component mux2to1NbitD
  generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       i_X	    : in std_logic;
       o_Y          : out std_logic_vector(N-1 downto 0));
end component;

signal sY1, sY2     : std_logic_vector(N-1 downto 0); 

begin
  mux1: mux4to1 port map(i_w0,i_w1,i_w2,i_w3,i_s0,i_s1,sY1);
  mux2: mux4to1 port map(i_w4,i_w5,i_w6,i_w7,i_s0,i_s1,sY2);
  mux3: mux2to1NbitD port map(sY1,sY2,i_s2,o_Y);
end structure;
