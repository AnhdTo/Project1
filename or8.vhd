library IEEE;
use IEEE.std_logic_1164.all;

entity or8 is
  port(i0, i1, i2, i3, i4, i5, i6, i7 : in std_logic;
       output : out std_logic);
end or8;

architecture behavior of or8 is
begin
  process
  begin
    output <= i0 OR i1 OR i2 OR i3 OR i4 OR i5 OR i6 OR i7;
    wait for 100 ns;
  end process;
end behavior;
