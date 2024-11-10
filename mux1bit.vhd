library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux1bit is
    Port ( dct : in  std_logic;
           gen : in  std_logic;
           sel : in  STD_LOGIC;
           y : out  std_logic );
end mux1bit;

architecture Behavioral of mux1bit is
begin
    y <= dct when sel = '1' else gen; -- cuidado aqui
end Behavioral;

