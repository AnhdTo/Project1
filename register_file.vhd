library IEEE;
use IEEE.std_logic_1164.all;

entity register_file is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
	   i_RST        : in std_logic;     -- Reset input
	   i_E          : in std_logic;     -- Write Enable
	   i_RS         : in std_logic_vector(4 downto 0);      -- Read Data select 1
	   i_RT         : in std_logic_vector(4 downto 0);      -- Read Data select 2
	   i_WE         : in std_logic_vector(4 downto 0);      -- Write Data select
	   i_WD         : in std_logic_vector(31 downto 0);     -- Write Data value
       o_REG        : out std_logic_vector(31 downto 0);
	   o_RS          : out std_logic_vector(31 downto 0);   -- Data value output
	   o_RT          : out std_logic_vector(31 downto 0));  -- Data value output

end register_file;

architecture structural of register_file is

component register_32bit
  port(i_CLK      : in std_logic;     -- Clock input
    i_RST        : in std_logic;     -- Reset input
    i_WE         : in std_logic;     -- Write select input
    i_D          : in std_logic_vector(31 downto 0);     -- Data value input
    o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
end component;

component decoder_5_to_32
  port(i_E          : in std_logic;      -- Write Enable
	   i_D          : in std_logic_vector(4 downto 0);      -- Data value input
       o_F          : out std_logic_vector(31 downto 0));   -- Data value output
end component;

component multiplexer_32bit_32_to_1
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
end component;

signal s_WE    : std_logic_vector(31 downto 0);    -- selected output index
type registers is array (0 to 31) of std_logic_vector(31 downto 0);
signal my_memory : registers;

begin
			 
decoder_WE: decoder_5_to_32
	port map(i_E => i_E,
			 i_D => i_WE,
			 o_F => s_WE);
			 
o_REG <= my_memory(2);
			
mux_rs: multiplexer_32bit_32_to_1
	port map(i_S => i_RS,
	   i_D0 => my_memory(0),
	   i_D1 => my_memory(1),
	   i_D2 => my_memory(2),
	   i_D3 => my_memory(3),
	   i_D4 => my_memory(4),
	   i_D5 => my_memory(5),
	   i_D6 => my_memory(6),
	   i_D7 => my_memory(7),
	   i_D8 => my_memory(8),
	   i_D9 => my_memory(9),
	   i_D10 => my_memory(10),
	   i_D11 => my_memory(11),
	   i_D12 => my_memory(12),
	   i_D13 => my_memory(13),
	   i_D14 => my_memory(14),
	   i_D15 => my_memory(15),
	   i_D16 => my_memory(16),
	   i_D17 => my_memory(17),
	   i_D18 => my_memory(18),
	   i_D19 => my_memory(19),
	   i_D20 => my_memory(20),
	   i_D21 => my_memory(21),
	   i_D22 => my_memory(22),
	   i_D23 => my_memory(23),
	   i_D24 => my_memory(24),
	   i_D25 => my_memory(25),
	   i_D26 => my_memory(26),
	   i_D27 => my_memory(27),
	   i_D28 => my_memory(28),
	   i_D29 => my_memory(29),
	   i_D30 => my_memory(30),
	   i_D31 => my_memory(31),
       o_F => o_RS);

mux_rt: multiplexer_32bit_32_to_1
	port map(i_S => i_RT,
	   i_D0 => my_memory(0),
	   i_D1 => my_memory(1),
	   i_D2 => my_memory(2),
	   i_D3 => my_memory(3),
	   i_D4 => my_memory(4),
	   i_D5 => my_memory(5),
	   i_D6 => my_memory(6),
	   i_D7 => my_memory(7),
	   i_D8 => my_memory(8),
	   i_D9 => my_memory(9),
	   i_D10 => my_memory(10),
	   i_D11 => my_memory(11),
	   i_D12 => my_memory(12),
	   i_D13 => my_memory(13),
	   i_D14 => my_memory(14),
	   i_D15 => my_memory(15),
	   i_D16 => my_memory(16),
	   i_D17 => my_memory(17),
	   i_D18 => my_memory(18),
	   i_D19 => my_memory(19),
	   i_D20 => my_memory(20),
	   i_D21 => my_memory(21),
	   i_D22 => my_memory(22),
	   i_D23 => my_memory(23),
	   i_D24 => my_memory(24),
	   i_D25 => my_memory(25),
	   i_D26 => my_memory(26),
	   i_D27 => my_memory(27),
	   i_D28 => my_memory(28),
	   i_D29 => my_memory(29),
	   i_D30 => my_memory(30),
	   i_D31 => my_memory(31),
       o_F => o_RT);
	   
register_0:  register_32bit
    port map(i_CLK => i_CLK,
    i_RST => '1',
    i_WE => '0',
    i_D => i_WD,
    o_Q => my_memory(0));

G1: for i in 1 to N-1 generate
  register_i:  register_32bit
    port map(i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => s_WE(i),
    i_D => i_WD,
    o_Q => my_memory(i));
end generate;
  
end structural;