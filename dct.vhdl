library ieee;
library xil_defaultlib;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;
use xil_defaultlib.fixed_pkg.all;
--use ieee.fixed_pkg.all;

entity dct is
    port (
    pixel0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    pixel1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    pixel2 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    pixel3 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    pixel4 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    pixel5 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    pixel6 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    pixel7 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    clk : in STD_LOGIC;
    en : in STD_LOGIC_VECTOR ( 1 downto 0 );
    resetar : in STD_LOGIC_VECTOR ( 1 downto 0 );
    BRAM_addr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_clk : out STD_LOGIC;
    BRAM_datain0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_datain1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_datain2 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_datain3 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_datain4 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_datain5 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_datain6 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_datain7 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_en : out STD_LOGIC;
    BRAM_rst : out STD_LOGIC;
    BRAM_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sel : out STD_LOGIC;
    finished : out STD_LOGIC;
    temp_soma_out : out STD_LOGIC_VECTOR ( 7 downto 0 );
    en_signal_out : out STD_LOGIC;
    valid_out : out STD_LOGIC;
    address_out : out STD_LOGIC_VECTOR ( 31 downto 0 )


    );
end entity dct;


architecture bhv of dct is

    signal temp_soma : unsigned (7 downto 0):="00000000"; 
    signal finished_signal : std_logic :='0';
    signal en_signal : std_logic := '0';
    signal valid : std_logic := '0';
    signal address : unsigned(31 downto 0):= X"0000_0000";
    signal eight_pixel_array : array_of_8_sfixed;
    signal layer1, layer2, layer3, layer4, layer5 : array_of_8_sfixed := ((others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'));
    signal layer0_reg, layer1_reg, layer2_reg, layer3_reg, layer4_reg, layer5_reg,eight_pixel_array_transformed : array_of_8_sfixed :=( (others => '0'),                                                                                                                                     
                                                                                                                                        (others => '0'),
                                                                                                                                        (others => '0'),
                                                                                                                                        (others => '0'),
                                                                                                                                        (others => '0'),
                                                                                                                                        (others => '0'),
                                                                                                                                        (others => '0'),
                                                                                                                                        (others => '0'));
    
begin

    eight_pixel_array <= (to_sfixed(pixel0,11,-20),
                          to_sfixed(pixel1,11,-20),
                          to_sfixed(pixel2,11,-20),
                          to_sfixed(pixel3,11,-20),
                          to_sfixed(pixel4,11,-20),
                          to_sfixed(pixel5,11,-20),
                          to_sfixed(pixel6,11,-20),
                          to_sfixed(pixel7,11,-20));
    
    
    registers: process (clk)
    begin
        if (rising_edge(clk)) then
            layer0_reg <= eight_pixel_array;
            layer1_reg <= layer1;
            layer2_reg <= layer2;
            layer3_reg <= layer3; 
            layer4_reg <= layer4;
            layer5_reg <= layer5;
            eight_pixel_array_transformed <= layer5_reg;       
        end if;
        
    end process registers;

    proc_name: process(clk)
    begin
    
        if rising_edge(clk) then
            if finished_signal = '0' then
                if (unsigned(temp_soma) >= 7 and unsigned(temp_soma) <15 )then            
                    valid <= '1';        
                end if;
                if (unsigned(temp_soma) >= 15  )then            
                    valid <= '0';        
                end if;
                if valid ='1' then
                    address <= address+1;        
                end if;
            else 
                valid <= '0';
                address <= X"0000_0000";
            end if;    
        end if;      
        
    end process proc_name;

    en_signal_process: process(clk)
    begin
        
        if (rising_edge(clk)) then
            if finished_signal = '0' then
                if (temp_soma  = "00000000" and en(0)='1') then  
                    en_signal <= '1'; 
                end if;
                if (temp_soma = "00001111" and en(0)='1') then
                    en_signal <= '0';
                end if;            
            else 
                en_signal <= '0';
            end if;
        end if;       
    end process en_signal_process;

    counting: process(clk)
    begin
        
        if (rising_edge(clk) ) then
            if finished_signal = '0' then 
                if en_signal = '1' then
                    temp_soma <= temp_soma +1;
                end if;
            else 
                temp_soma <= B"0000_0000";   
            end if ;      
        end if;
    end process counting;
    
    mux_process: process(clk)
    begin
        if (rising_edge(clk)) then     
            if finished_signal = '0' then              
                if unsigned(temp_soma) = 7 then
                    sel <= '1';
                end if;  
            else
                sel <= '0';
            end if;       
        end if;
    end process mux_process;
    
    finished_process: process(clk)
    begin
        if (rising_edge(clk)) then
            if resetar(1)='0' then
                if unsigned(temp_soma) = 16 then
                    finished_signal <= '1';
                end if;  
            else
                finished_signal<='0';
            end if;                 
        end if;
    end process finished_process;

    -- --Layer 1
    layer1(0) <= resize(arg => layer0_reg(0) + layer0_reg(7),
                        left_index => 11,
                        right_index => -20);
    layer1(1) <= resize(arg => layer0_reg(1) + layer0_reg(6),
                        left_index => 11,
                        right_index => -20);
    layer1(2) <= resize(arg => layer0_reg(2) + layer0_reg(5),
                        left_index => 11,
                        right_index => -20);
    layer1(3) <= resize(arg => layer0_reg(3) + layer0_reg(4),
                        left_index => 11,
                        right_index => -20);
    layer1(4) <= resize(arg => layer0_reg(3) - layer0_reg(4),
                        left_index => 11,
                        right_index => -20);
    layer1(5) <= resize(arg => layer0_reg(2) - layer0_reg(5),
                        left_index => 11,
                        right_index => -20);
    layer1(6) <= resize(arg => layer0_reg(1) - layer0_reg(6),
                        left_index => 11,
                        right_index => -20);
    layer1(7) <= resize(arg => layer0_reg(0) - layer0_reg(7),
                        left_index => 11,
                        right_index => -20);


    -- --Layer 2

    layer2(0) <= resize(arg => layer1_reg(0) + layer1_reg(3),
                        left_index => 11,
                        right_index => -20);
    layer2(1) <= resize(arg => layer1_reg(1) + layer1_reg(2),
                        left_index => 11,
                        right_index => -20);
    layer2(2) <= resize(arg => layer1_reg(1) - layer1_reg(2),
                        left_index => 11,
                        right_index => -20);
    layer2(3) <= resize(arg => layer1_reg(0) - layer1_reg(3),
                        left_index => 11,
                        right_index => -20);
    layer2(4) <= layer1_reg(4);
    layer2(5) <= resize(arg => cos_pi_over_4*layer1_reg(6) - cos_pi_over_4*layer1_reg(5),
                        left_index => 11,
                        right_index => -20);
    layer2(6) <= resize(arg => cos_pi_over_4*layer1_reg(6) + cos_pi_over_4*layer1_reg(5),
                        left_index => 11,
                        right_index => -20);          
    layer2(7) <= layer1_reg(7);

    --Layer 3

    layer3(0) <= resize(arg => layer2_reg(0)*cos_pi_over_4 + layer2_reg(1)*cos_pi_over_4 ,
                        left_index => 11,
                        right_index => -20);    
    layer3(1) <= resize(arg => layer2_reg(0)*cos_pi_over_4 - layer2_reg(1)*cos_pi_over_4,
                        left_index => 11,
                        right_index => -20);
    layer3(2) <= resize(arg => layer2_reg(2)*sin_pi_over_8 + layer2_reg(3)*cos_pi_over_8,
                        left_index => 11,
                        right_index => -20);
    layer3(3) <= resize(arg => layer2_reg(3)*cos_3pi_over_8 - layer2_reg(2)*sin_3pi_over_8,
                        left_index => 11,
                        right_index => -20);
    layer3(4) <= resize(arg => layer2_reg(4) + layer2_reg(5),
                        left_index => 11,
                        right_index => -20);
    layer3(5) <= resize(arg => layer2_reg(4) - layer2_reg(5),
                        left_index => 11,
                        right_index => -20);
    layer3(6) <= resize(arg => layer2_reg(7) - layer2_reg(6),
                        left_index => 11,
                        right_index => -20);
    layer3(7) <= resize(arg => layer2_reg(7) + layer2_reg(6),
                        left_index => 11,
                        right_index => -20);
    

    --Layer 4

    
    layer4(0) <= resize(arg => layer3_reg(0),
                        left_index => 11,
                        right_index => -20); --F0    
    layer4(1) <= resize(arg => layer3_reg(1),
                        left_index => 11,
                        right_index => -20); --F4    
    layer4(2) <= resize(arg => layer3_reg(2),
                        left_index => 11,
                        right_index => -20); --F2    
    layer4(3) <= resize(arg => layer3_reg(3),
                        left_index => 11,
                        right_index => -20); --F6    
    layer4(4) <= resize(arg => layer3_reg(4)*sin_pi_over_16 + layer3_reg(7)*cos_pi_over_16,
                        left_index => 11,
                        right_index => -20); --F1    
    layer4(5) <= resize(arg => layer3_reg(5)*sin_5pi_over_16 + layer3_reg(6)*cos_5pi_over_16,
                        left_index => 11,
                        right_index => -20); --F5    
    layer4(6) <= resize(arg => layer3_reg(6)*cos_3pi_over_16 - layer3_reg(5)*sin_3pi_over_16,
                        left_index => 11,
                        right_index => -20); --F3    
    layer4(7) <= resize(arg => layer3_reg(7)*cos_7pi_over_16 - layer3_reg(4)*sin_7pi_over_16,
                        left_index => 11,
                        right_index => -20); --F7

    
    -- --Layer 5 

    layer5(0) <= resize(arg => layer4_reg(0) / 2,
                        left_index => 11,
                        right_index => -20); --F0
    layer5(1) <= resize(arg => layer4_reg(4) / 2,
                        left_index => 11,
                        right_index => -20); --F1
    layer5(2) <= resize(arg => layer4_reg(2) / 2,
                        left_index => 11,
                        right_index => -20); --F2
    layer5(3) <= resize(arg => layer4_reg(6) / 2,
                        left_index => 11,
                        right_index => -20); --F3
    layer5(4) <= resize(arg => layer4_reg(1) / 2,
                        left_index => 11,
                        right_index => -20); --F4
    layer5(5) <= resize(arg => layer4_reg(5) / 2,
                        left_index => 11,
                        right_index => -20); --F5
    layer5(6) <= resize(arg => layer4_reg(3) / 2,
                        left_index => 11,
                        right_index => -20); --F6
    layer5(7) <= resize(arg => layer4_reg(7) / 2,
                        left_index => 11,
                        right_index => -20); --F7

    


    --BRAM_addr <= std_logic_vector(address) sll 2 ;   
    BRAM_addr <= std_logic_vector(unsigned(address) sll 2);
    --BRAM_addr <= X"40000000";
    BRAM_clk <= clk;
    BRAM_datain0 <= To_SLV(eight_pixel_array_transformed(0));
    BRAM_datain1 <= To_SLV(eight_pixel_array_transformed(1));
    BRAM_datain2 <= To_SLV(eight_pixel_array_transformed(2));
    BRAM_datain3 <= To_SLV(eight_pixel_array_transformed(3));
    BRAM_datain4 <= To_SLV(eight_pixel_array_transformed(4));
    BRAM_datain5 <= To_SLV(eight_pixel_array_transformed(5));
    BRAM_datain6 <= To_SLV(eight_pixel_array_transformed(6));
    BRAM_datain7 <= To_SLV(eight_pixel_array_transformed(7));
    BRAM_en <= valid;
    BRAM_rst <= '0';
    BRAM_we <= "1111";
    temp_soma_out  <= std_logic_vector(temp_soma);
    en_signal_out  <= en_signal;
    valid_out <= valid;
    address_out <= std_logic_vector(address);
    finished <= finished_signal;
    

    

    
end architecture bhv;

