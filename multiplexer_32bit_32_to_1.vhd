library IEEE;
use IEEE.std_logic_1164.all;

entity multiplexer_32bit_32_to_1 is
  port(i_S          : in std_logic_vector(4 downto 0);      -- Data select
	   i_D0         : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D1         : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D2         : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D3         : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D4         : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D5         : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D6         : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D7         : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D8         : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D9         : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D10        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D11        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D12        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D13        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D14        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D15        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D16        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D17        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D18        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D19        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D20        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D21        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D22        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D23        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D24        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D25        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D26        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D27        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D28        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D29        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D30        : in std_logic_vector(31 downto 0);     -- Data value input
	   i_D31        : in std_logic_vector(31 downto 0);     -- Data value input
       o_F          : out std_logic_vector(31 downto 0));   -- Data value output

end multiplexer_32bit_32_to_1;

architecture structural of multiplexer_32bit_32_to_1 is

component decoder_5_to_32
  port(i_E          : in std_logic;      -- Write Enable
	   i_D          : in std_logic_vector(4 downto 0);      -- Data value input
       o_F          : out std_logic_vector(31 downto 0));   -- Data value output
end component;

signal s_S, s_F    : std_logic_vector(31 downto 0);    -- selected output index
type registers is array (0 to 32) of std_logic_vector(31 downto 0);
signal my_registers : registers;

begin

decoder_5_to_32_1: decoder_5_to_32
	port map(i_E => '1',
			 i_D => i_S,
			 o_F => s_S);
process(i_D0, i_D1, i_D2, i_D3, i_D4, i_D5, i_D6, i_D7, i_D8, i_D9, i_D10, i_D11, i_D12, i_D13, i_D14, i_D15, i_D16, i_D17, i_D18, i_D19, i_D20, i_D21, i_D22, i_D23, i_D24, i_D25, i_D26, i_D27, i_D28, i_D29, i_D30, i_D31)
begin
my_registers(0) <= i_D0;
my_registers(1) <= i_D1;
my_registers(2) <= i_D2;
my_registers(3) <= i_D3;
my_registers(4) <= i_D4;
my_registers(5) <= i_D5;
my_registers(6) <= i_D6;
my_registers(7) <= i_D7;
my_registers(8) <= i_D8;
my_registers(9) <= i_D9;
my_registers(10) <= i_D10;
my_registers(11) <= i_D11;
my_registers(12) <= i_D12;
my_registers(13) <= i_D13;
my_registers(14) <= i_D14;
my_registers(15) <= i_D15;
my_registers(16) <= i_D16;
my_registers(17) <= i_D17;
my_registers(18) <= i_D18;
my_registers(19) <= i_D19;
my_registers(20) <= i_D20;
my_registers(21) <= i_D21;
my_registers(22) <= i_D22;
my_registers(23) <= i_D23;
my_registers(24) <= i_D24;
my_registers(25) <= i_D25;
my_registers(26) <= i_D26;
my_registers(27) <= i_D27;
my_registers(28) <= i_D28;
my_registers(29) <= i_D29;
my_registers(30) <= i_D30;
my_registers(31) <= i_D31;
end process;

o_F <= s_F;

-- G1: for i in 0 to 31 loop
  -- with s_S(i) select 
	-- s_F <= my_registers(i) when '1',
		   -- s_F when others;

-- end loop G1;

process(s_S, my_registers)
begin

	for i in 0 to 31 loop

	  if (s_S(i) = '1') then
		s_F <= my_registers(i);
	  end if;

	end loop;
end process;
  
end structural;