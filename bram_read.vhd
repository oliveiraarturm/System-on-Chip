library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bram_read is
    port ( 
        clk : in std_logic;
        start_reading : in std_logic_vector(1 downto 0);
        BRAM_addr : out std_logic_vector(31 downto 0);
        BRAM_clk : out std_logic;
        BRAM_dataout0 : in std_logic_vector(31 downto 0):=X"0000_0000";
        BRAM_dataout1 : in std_logic_vector(31 downto 0):=X"0000_0000";
        BRAM_dataout2 : in std_logic_vector(31 downto 0):=X"0000_0000";
        BRAM_dataout3 : in std_logic_vector(31 downto 0):=X"0000_0000";
        BRAM_dataout4 : in std_logic_vector(31 downto 0):=X"0000_0000";
        BRAM_dataout5 : in std_logic_vector(31 downto 0):=X"0000_0000";
        BRAM_dataout6 : in std_logic_vector(31 downto 0):=X"0000_0000";
        BRAM_dataout7 : in std_logic_vector(31 downto 0):=X"0000_0000";
        BRAM_en  : out std_logic;
        BRAM_rst : out std_logic;
        BRAM_we : out std_logic_vector(3 downto 0);
        soma : out std_logic_vector(7 downto 0);
        address_out: out std_logic_vector(31 downto 0);
        reading_internal_out : out std_logic;
        finished : in std_logic
     );
end bram_read;

architecture Behavioral of bram_read is
    
    signal reading_internal : std_logic;
    signal temp_soma : unsigned (7 downto 0):="00000000"; 
    signal address : unsigned(31 downto 0):= X"0000_0000";
    signal data_readed0 : std_logic_vector(31 downto 0):=X"0000_0000";
    signal data_readed1 : std_logic_vector(31 downto 0):=X"0000_0000";
    signal data_readed2 : std_logic_vector(31 downto 0):=X"0000_0000";
    signal data_readed3 : std_logic_vector(31 downto 0):=X"0000_0000";
    signal data_readed4 : std_logic_vector(31 downto 0):=X"0000_0000";
    signal data_readed5 : std_logic_vector(31 downto 0):=X"0000_0000";
    signal data_readed6 : std_logic_vector(31 downto 0):=X"0000_0000";
    signal data_readed7 : std_logic_vector(31 downto 0):=X"0000_0000";

begin


    process (clk)
    begin        
        if (rising_edge(clk)) then
            if finished = '0' then
                if (start_reading(0) = '1') then                
                    reading_internal <= '1'; 
                end if;
                if (unsigned(temp_soma) >= 7) then
                    reading_internal <= '0';
                end if;            
            else
                reading_internal <= '0';            
            end if; 
        end if;        
    end process;


    process(clk)    
    begin
        if rising_edge(clk) then 
            if finished = '0' then
                if (reading_internal = '1' and unsigned(temp_soma) <= 6 ) then
                    temp_soma <= temp_soma + 1;
                    address <= address + 1;             
                end if;
            else
                temp_soma <= B"0000_0000";
                address <= X"0000_0000";
            end if; 
        end if;
    end process; 

    BRAM_addr <= std_logic_vector(unsigned(address) sll 2);
    --BRAM_addr <= X"40000000";
    BRAM_clk <= clk;
    data_readed0 <= BRAM_dataout0;
    data_readed1 <= BRAM_dataout1;
    data_readed2 <= BRAM_dataout2;
    data_readed3 <= BRAM_dataout3;
    data_readed4 <= BRAM_dataout4;
    data_readed5 <= BRAM_dataout5;
    data_readed6 <= BRAM_dataout6;
    data_readed7 <= BRAM_dataout7;
    BRAM_en <= reading_internal;
    BRAM_rst <= '0';
    BRAM_we <= "0000";
    soma <= std_logic_vector(temp_soma);
    address_out<=std_logic_vector(address);
    reading_internal_out<=reading_internal;
    
    
end Behavioral;
