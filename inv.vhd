library IEEE;
use IEEE.std_logic_1164.all;

entity inv is

  port(input          : in std_logic;
       output          : out std_logic);

end inv;

architecture dataflow of inv is
begin

  output <= not input;
  
end dataflow;