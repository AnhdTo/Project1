library IEEE;
use IEEE.std_logic_1164.all;

entity right_shift32 is
  generic(N : integer := 32);
  port(dataIn              : in std_logic_vector(N-1 downto 0);
       AorL                : in std_logic; --0 = Logical, 1 = Arithmetic
       sel	           : in std_logic_vector(4 downto 0);
       output          	   : out std_logic_vector(N-1 downto 0));
end right_shift32;

architecture structure of right_shift32 is

component mux2to1
  port(i_A          : in std_logic;
       i_B	    : in std_logic;
       i_X	    : in std_logic;
       o_Y          : out std_logic);
end component;

signal shiftIn : std_logic := '0';
signal shift0, shift1, shift2, shift3 : std_logic_vector(31 downto 0);

begin

Arith_or_Logic: process(dataIn,AorL,sel)
begin

if((AorL = '1') AND (dataIn(31) = '1')) then
    shiftIn <= '1';
else
    shiftIn <= '0';
end if;
end process Arith_or_Logic;


mux0_31 : mux2to1 port map(dataIn(31),shiftIn,sel(0),shift0(31));
G0: for i in 30 downto 0 generate
  mux0_i : mux2to1 port map(dataIn(i),dataIn(i+1),sel(0),shift0(i));
end generate;


mux1_31 : mux2to1 port map(shift0(31),shiftIn,sel(1),shift1(31));
mux1_30 : mux2to1 port map(shift0(30),shiftIn,sel(1),shift1(30));
G1: for i in 29 downto 0 generate 
  mux1_i : mux2to1 port map(shift0(i),shift0(i+2),sel(1),shift1(i));
end generate;


mux2_31 : mux2to1 port map(shift1(31),shiftIn,sel(2),shift2(31));
mux2_30 : mux2to1 port map(shift1(30),shiftIn,sel(2),shift2(30));
mux2_29 : mux2to1 port map(shift1(29),shiftIn,sel(2),shift2(29));
mux2_28 : mux2to1 port map(shift1(28),shiftIn,sel(2),shift2(28));
G2: for i in 27 downto 0 generate
  mux2_i : mux2to1 port map(shift1(i),shift1(i+4),sel(2),shift2(i));
end generate;


G3_1: for i in 31 downto 24 generate
  mux3_i : mux2to1 port map(shift2(i),shiftIn,sel(3),shift3(i));
end generate;
G3_2: for i in 23 downto 0 generate
  mux3_i : mux2to1 port map(shift2(i),shift2(i+8),sel(3),shift3(i));
end generate;


G4_1: for i in 31 downto 16 generate
  mux4_i: mux2to1 port map(shift3(i),shiftIn,sel(4),output(i));
end generate;
G4_2: for i in 15 downto 0 generate
  mux4_i : mux2to1 port map(shift3(i),shift3(i+16),sel(4),output(i));
end generate;

end structure;