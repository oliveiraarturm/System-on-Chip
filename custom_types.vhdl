library IEEE;
library xil_defaultlib;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use xil_defaultlib.fixed_pkg.all;
--use ieee.fixed_pkg.all;




package custom_types is
    constant cos_pi_over_4 : sfixed(11 downto -20) := X"000_B504F";
    constant cos_pi_over_8 : sfixed(11 downto -20) := X"000_EC835";
    constant cos_3pi_over_8 : sfixed(11 downto -20) := X"000_61F78";
    constant cos_pi_over_16 : sfixed(11 downto -20) := X"000_FB14B"; 
    constant cos_3pi_over_16: sfixed(11 downto -20) := X"000_D4DB3";
    constant cos_5pi_over_16: sfixed(11 downto -20) := X"000_8E39D";
    constant cos_7pi_over_16: sfixed(11 downto -20) := X"000_31F17";
    constant sin_pi_over_8: sfixed(11 downto -20) := X"000_61F78";
    constant sin_3pi_over_8 : sfixed(11 downto -20) := X"000_EC835";
    constant sin_pi_over_16 : sfixed(11 downto -20) := X"000_31F17";
    constant sin_3pi_over_16 : sfixed(11 downto -20) := X"000_8E39D";
    constant sin_5pi_over_16 : sfixed(11 downto -20) := X"000_D4DB3";
    constant sin_7pi_over_16 : sfixed(11 downto -20) := X"000_FB14B";
    
    --type array_of_8_pixel is array (0 to 7) of std_logic_vector(31 to 0);
    --type array_of_8_pixel is array (0 to 7) of pixel;

    type array_of_8_sfixed is array (0 to 7) of sfixed(11 downto -20);
    --function to_array_of_8_sfixed(array_of_8_pixel_var : array_of_8_pixel) return array_of_8_sfixed;
    
end package custom_types;


-- package body custom_types is
--     -- Function definition
--     function to_array_of_8_sfixed(array_of_8_pixel_var : array_of_8_pixel) return array_of_8_sfixed is
--         variable array_of_8_sfixed_var : array_of_8_sfixed;
--         variable a : sfixed(11 downto -20);
--     begin
--         for i in 0 to 7 loop
--             array_of_8_sfixed_var(i) := to_sfixed(to_integer(unsigned(array_of_8_pixel_var(i))),a );
--         end loop;
--         return array_of_8_sfixed_var;
--     end function to_array_of_8_sfixed;

-- end package body custom_types;