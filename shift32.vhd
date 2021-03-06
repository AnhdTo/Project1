library IEEE;
use IEEE.std_logic_1164.all;

entity shift32 is
  generic(N : integer := 32);
  port(dataIn              : in std_logic_vector(N-1 downto 0);
       AorL                : in std_logic; --0 = Logical, 1 = Arithmetic
       dir		   : in std_logic; --0 = left, 1 = right
       sel	           : in std_logic_vector(4 downto 0);
       output          	   : out std_logic_vector(N-1 downto 0));
end shift32;

architecture structure of shift32 is

component right_shift32
  generic(N : integer := 32);
  port(dataIn              : in std_logic_vector(N-1 downto 0);
       AorL                : in std_logic; --0 = Logical, 1 = Arithmetic
	   dir                 : in std_logic;
       sel	           : in std_logic_vector(4 downto 0);
       output          	   : out std_logic_vector(N-1 downto 0));
end component;

component mux2to1Nbit
  generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       i_X	    : in std_logic;
       o_Y          : out std_logic_vector(N-1 downto 0));
end component;

signal sMuxOut,sOutput,dataInBack,sOutputBack, s_dataIn : std_logic_vector(31 downto 0);
signal s_sel    : std_logic_vector(4 downto 0); -- "10000" when executing lui, sel when executing other shift

begin

s_dataIn <= dataIn;

G1: for i in 0 to N-1 generate
  dataInBack(i) <= s_dataIn((N-1)-i);
end generate;

mux1: mux2to1Nbit port map(dataInBack,s_dataIn,dir,sMuxOut);

s_sel <= "10000" when (AorL = '1' and dir = '0') else
		sel;

shifter: right_shift32 port map(sMuxOut,AorL,dir,s_sel,sOutput);

G2: for i in 0 to N-1 generate
  sOutputBack(i) <= sOutput((N-1)-i);
end generate;

mux2: mux2to1Nbit port map(sOutputBack,sOutput,dir,output);

end structure;