----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.07.2024 01:32:16
-- Design Name: 
-- Module Name: testebench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
library xil_defaultlib;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench_postsyn is
--  Port ( );
end testbench_postsyn;

architecture Behavioral of testbench_postsyn is

  signal BRAM_PORTB_dout0 : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTB_dout1 : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTB_dout2 : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTB_dout3 : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTB_dout4 : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTB_dout5 : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTB_dout6 : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTB_dout7 : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTB_clkb : std_logic;
  signal BRAM_PORTB_addrb : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTB_enb : std_logic;
  signal BRAM_PORTB_web : STD_LOGIC_VECTOR(3 downto 0);
  signal mux_gen_in : STD_LOGIC_VECTOR (31 downto 0);
  signal mux_dct_in: STD_LOGIC_VECTOR(31 downto 0);
  signal mux1bit_gen_in : STD_LOGIC;
  signal mux1bit_dct_in: std_logic;
  signal mux4bits_gen_in : STD_LOGIC_VECTOR (3 downto 0);
  signal mux4bits_dct_in: STD_LOGIC_VECTOR(3 downto 0);
  signal BRAM_PORTB_rstb : std_logic;
  signal address_out_tb : STD_LOGIC_VECTOR (31 downto 0);
  signal clk_tb : std_logic := '1';
  signal reading_internal_out_tb : std_logic;
  signal soma_tb : STD_LOGIC_VECTOR(7 downto 0);
  signal start_reading_tb : std_logic_vector(1 downto 0):="00";
  constant clk_period_tb : time := 10 ns;
  signal sel_tb : std_logic := '0';
  signal BRAM_PORTB_dout0_fake : STD_LOGIC_VECTOR (31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dout1_fake : STD_LOGIC_VECTOR (31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dout2_fake : STD_LOGIC_VECTOR (31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dout3_fake : STD_LOGIC_VECTOR (31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dout4_fake : STD_LOGIC_VECTOR (31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dout5_fake : STD_LOGIC_VECTOR (31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dout6_fake : STD_LOGIC_VECTOR (31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dout7_fake : STD_LOGIC_VECTOR (31 downto 0):= X"0000_0000";
  signal dout0 : STD_LOGIC_VECTOR (31 downto 0);
  signal dout1 : STD_LOGIC_VECTOR (31 downto 0);
  signal dout2 : STD_LOGIC_VECTOR (31 downto 0);
  signal dout3 : STD_LOGIC_VECTOR (31 downto 0);
  signal dout4 : STD_LOGIC_VECTOR (31 downto 0);
  signal dout5 : STD_LOGIC_VECTOR (31 downto 0);
  signal dout6 : STD_LOGIC_VECTOR (31 downto 0);
  signal dout7 : STD_LOGIC_VECTOR (31 downto 0);
  signal limbo : std_logic;
  signal BRAM_PORTB_dinb0 : std_logic_vector(31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dinb1 : std_logic_vector(31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dinb2 : std_logic_vector(31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dinb3 : std_logic_vector(31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dinb4 : std_logic_vector(31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dinb5 : std_logic_vector(31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dinb6 : std_logic_vector(31 downto 0):= X"0000_0000";
  signal BRAM_PORTB_dinb7 : std_logic_vector(31 downto 0):= X"0000_0000";
  signal address_out_dct_tb : std_logic_vector(31 downto 0):= X"0000_0000";
  signal en_signal_out_tb : std_logic:='0';
  signal finished_tb : std_logic :='0';
  signal temp_soma_out_dct_tb : std_logic_vector(7 downto 0):= B"0000_0000";
  signal valid_out_dct_tb : std_logic:='0';
  
  
  
  type sinais is record
  
    dout0, dout1, dout2, dout3, dout4, dout5, dout6, dout7 : STD_LOGIC_VECTOR (31 downto 0);

  
  end record sinais;

  type conjunto_sinais is array (natural range <>) of sinais ;

  -- constant vetor_test : conjunto_sinais := (

  
  -- (X"0000000C", X"0000000A", X"00000008", X"0000000A", X"0000000C", X"0000000A", X"00000008", X"0000000B"),
  -- (X"0000000E", X"0000000E", X"00000008", X"0000000E", X"0000000E", X"00000002", X"0000000A", X"0000000B"),
  -- (X"00000008", X"00000009", X"0000000A", X"0000000B", X"0000000C", X"0000000D", X"0000000E", X"0000000F"),
  -- (X"0000000F", X"0000000E", X"0000000D", X"0000000C", X"0000000B", X"0000000A", X"00000009", X"00000008"),
  -- (X"00000009", X"00000009", X"0000000A", X"0000000B", X"0000000B", X"0000000C", X"0000000D", X"0000000E"),
  -- (X"0000000C", X"0000000D", X"0000000E", X"0000000F", X"00000008", X"00000009", X"0000000A", X"0000000B"),
  -- (X"0000000D", X"0000000C", X"0000000B", X"0000000A", X"00000009", X"00000008", X"0000000F", X"0000000E"),
  -- (X"0000000A", X"0000000C", X"0000000D", X"0000000F", X"0000000B", X"00000008", X"00000009", X"0000000E")
  

  -- );

  constant vetor_test : conjunto_sinais := (

    (X"00C_00000", X"00A_00000", X"008_00000", X"00A_00000", X"00C_00000", X"00A_00000", X"008_00000", X"00B_00000"),
    (X"00E_00000", X"00E_00000", X"008_00000", X"00E_00000", X"00E_00000", X"002_00000", X"00A_00000", X"00B_00000"),
    (X"008_00000", X"009_00000", X"00A_00000", X"00B_00000", X"00C_00000", X"00D_00000", X"00E_00000", X"00F_00000"),
    (X"00F_00000", X"00E_00000", X"00D_00000", X"00C_00000", X"00B_00000", X"00A_00000", X"009_00000", X"008_00000"),
    (X"009_00000", X"009_00000", X"00A_00000", X"00B_00000", X"00B_00000", X"00C_00000", X"00D_00000", X"00E_00000"),
    (X"00C_00000", X"00D_00000", X"00E_00000", X"00F_00000", X"008_00000", X"009_00000", X"00A_00000", X"00B_00000"),
    (X"00D_00000", X"00C_00000", X"00B_00000", X"00A_00000", X"009_00000", X"008_00000", X"00F_00000", X"00E_00000"),
    (X"00A_00000", X"00C_00000", X"00D_00000", X"00F_00000", X"00B_00000", X"008_00000", X"009_00000", X"00E_00000")
  );
  

  component design_1_bram_read_0_0 is
  port (
    clk : in STD_LOGIC;
    start_reading : in STD_LOGIC_VECTOR ( 1 downto 0 );
    BRAM_addr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_clk : out STD_LOGIC;
    BRAM_dataout0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_dataout1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_dataout2 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_dataout3 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_dataout4 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_dataout5 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_dataout6 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_dataout7 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_en : out STD_LOGIC;
    BRAM_rst : out STD_LOGIC;
    BRAM_we : out STD_LOGIC_VECTOR ( 3 downto 0 );
    soma : out STD_LOGIC_VECTOR ( 7 downto 0 );
    address_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    reading_internal_out : out STD_LOGIC;
    finished : in STD_LOGIC
  );
  end component design_1_bram_read_0_0;

  component design_1_dct_0_0 is
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
    end component design_1_dct_0_0;
  
  component design_1_mux_0_0 is
    port (
      dct : in STD_LOGIC_VECTOR ( 31 downto 0 );
      gen : in STD_LOGIC_VECTOR ( 31 downto 0 );
      sel : in STD_LOGIC;
      y : out STD_LOGIC_VECTOR ( 31 downto 0 )
    );
  end component design_1_mux_0_0;

  component design_1_mux1bit_0_0 is
    port (
      dct : in STD_LOGIC;
      gen : in STD_LOGIC;
      sel : in STD_LOGIC;
      y : out STD_LOGIC
    );
  end component design_1_mux1bit_0_0;

  component design_1_mux4bits_0_0 is
    port (
      dct : in STD_LOGIC_VECTOR ( 3 downto 0 );
      gen : in STD_LOGIC_VECTOR ( 3 downto 0 );
      sel : in STD_LOGIC;
      y : out STD_LOGIC_VECTOR ( 3 downto 0 )
    );
  end component design_1_mux4bits_0_0;

begin
    
    bram_read_tb: component design_1_bram_read_0_0
     port map (
      BRAM_addr(31 downto 0) => mux_gen_in,
      BRAM_clk => BRAM_PORTB_clkb,
      BRAM_dataout0(31 downto 0) => BRAM_PORTB_dout0,
      BRAM_dataout1(31 downto 0) => BRAM_PORTB_dout1,
      BRAM_dataout2(31 downto 0) => BRAM_PORTB_dout2,
      BRAM_dataout3(31 downto 0) => BRAM_PORTB_dout3,
      BRAM_dataout4(31 downto 0) => BRAM_PORTB_dout4,
      BRAM_dataout5(31 downto 0) => BRAM_PORTB_dout5,
      BRAM_dataout6(31 downto 0) => BRAM_PORTB_dout6,
      BRAM_dataout7(31 downto 0) => BRAM_PORTB_dout7,
      BRAM_en => mux1bit_gen_in,
      BRAM_rst => BRAM_PORTB_rstb,
      BRAM_we(3 downto 0) => mux4bits_gen_in ,
      address_out(31 downto 0) =>address_out_tb ,
      clk => clk_tb,
      reading_internal_out => reading_internal_out_tb,
      soma(7 downto 0) => soma_tb,
      start_reading => start_reading_tb,
      finished => finished_tb
    );

    dct_tb: component design_1_dct_0_0
      port map (
       BRAM_addr(31 downto 0) => mux_dct_in,
       BRAM_clk => open,
       BRAM_datain0(31 downto 0) => BRAM_PORTB_dinb0,
       BRAM_datain1(31 downto 0) => BRAM_PORTB_dinb1,
       BRAM_datain2(31 downto 0) => BRAM_PORTB_dinb2,
       BRAM_datain3(31 downto 0) => BRAM_PORTB_dinb3,
       BRAM_datain4(31 downto 0) => BRAM_PORTB_dinb4,
       BRAM_datain5(31 downto 0) => BRAM_PORTB_dinb5,
       BRAM_datain6(31 downto 0) => BRAM_PORTB_dinb6,
       BRAM_datain7(31 downto 0) => BRAM_PORTB_dinb7,
       BRAM_en => mux1bit_dct_in,
       BRAM_rst => open,
       BRAM_we(3 downto 0) => mux4bits_dct_in,
       address_out(31 downto 0) => address_out_dct_tb,
       clk => clk_tb,
       en => start_reading_tb,
       en_signal_out => en_signal_out_tb,
       finished => finished_tb,
       pixel0(31 downto 0) => BRAM_PORTB_dout0_fake, -- truncada
       pixel1(31 downto 0) => BRAM_PORTB_dout1_fake, -- truncada
       pixel2(31 downto 0) => BRAM_PORTB_dout2_fake, -- truncada
       pixel3(31 downto 0) => BRAM_PORTB_dout3_fake, -- truncada
       pixel4(31 downto 0) => BRAM_PORTB_dout4_fake, -- truncada
       pixel5(31 downto 0) => BRAM_PORTB_dout5_fake, -- truncada
       pixel6(31 downto 0) => BRAM_PORTB_dout6_fake, -- truncada
       pixel7(31 downto 0) => BRAM_PORTB_dout7_fake, -- truncada
       sel => sel_tb,
       temp_soma_out(7 downto 0) => temp_soma_out_dct_tb,
       valid_out => valid_out_dct_tb,
       resetar => start_reading_tb
     );

    mux_tb: component design_1_mux_0_0
      port map (
       dct(31 downto 0) => mux_dct_in,
       gen(31 downto 0) => mux_gen_in,
       sel => sel_tb,
       y(31 downto 0) => BRAM_PORTB_addrb
     );
    
    mux1bit_tb: component design_1_mux1bit_0_0
    port map (
      dct => mux1bit_dct_in,
      gen => mux1bit_gen_in,
      sel => sel_tb,
      y => BRAM_PORTB_enb
    );    

    mux4bits_tb: component design_1_mux4bits_0_0
      port map (
       dct(3 downto 0) => mux4bits_dct_in,
       gen(3 downto 0) => mux4bits_gen_in,
       sel => sel_tb,
       y(3 downto 0) => BRAM_PORTB_web
     );

    

    signal_generation_process: process

    begin
        wait for 75ns;
        for i in 0 to vetor_test'length-1 loop
          BRAM_PORTB_dout0_fake <= vetor_test(i).dout0;
          BRAM_PORTB_dout1_fake <= vetor_test(i).dout1;
          BRAM_PORTB_dout2_fake <= vetor_test(i).dout2;
          BRAM_PORTB_dout3_fake <= vetor_test(i).dout3;
          BRAM_PORTB_dout4_fake <= vetor_test(i).dout4;
          BRAM_PORTB_dout5_fake <= vetor_test(i).dout5;
          BRAM_PORTB_dout6_fake <= vetor_test(i).dout6;
          BRAM_PORTB_dout7_fake <= vetor_test(i).dout7;
          wait for 10 ns;
        end loop;
        wait;

    end process signal_generation_process;

    clk_process: process
    begin
        clk_tb <= not clk_tb; 
        wait for clk_period_tb/2;
    end process clk_process;

    start_reading_process: process
    begin        
        wait for 55ns;
        start_reading_tb <= "01" after 1ps;
        wait for 300ns;
        start_reading_tb <= "10" ;
        wait;
        
    end process start_reading_process;

    
    

end Behavioral;
