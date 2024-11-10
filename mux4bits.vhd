library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4bits is
    Port ( dct : in  std_logic_vector(3 downto 0);
           gen : in  std_logic_vector(3 downto 0);
           sel : in  STD_LOGIC;
           y : out  std_logic_vector(3 downto 0) );
end mux4bits;

architecture Behavioral of mux4bits is
begin
    y <= dct when sel = '1' else gen; -- cuidado aqui
end Behavioral;
