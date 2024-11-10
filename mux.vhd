library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    Port ( dct : in  std_logic_vector(31 downto 0);
           gen : in  std_logic_vector(31 downto 0);
           sel : in  STD_LOGIC;
           y : out  std_logic_vector(31 downto 0));
end mux;

architecture Behavioral of mux is
begin
    y <= dct when sel = '1' else gen; -- cuidado aqui
end Behavioral;

