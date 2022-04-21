------------------------------------------------------------
-- Design of Testbench
-- 20.04.2022
-- Our group

------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------
entity UART_Tb is
    -- Entity of testbench is always empty
end entity UART_Tb;

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------
architecture testbench of UART_Tb is

    -- Local constants for Tx and Rx
    constant c_CLK_100MHZ_PERIOD : time := 10 ns;
    
    -- Local signals for Tx and Rx
    signal s_clk_100MHz : std_logic;

    --Local signals for Tx
    signal s_Tx_start   : std_logic;
    signal s_Tx_byte    : std_logic_vector(7 downto 0);
    signal s_Tx_serial  : std_logic;
    signal s_Tx_active  : std_logic;
    signal s_Tx_done    : std_logic;
    
    --Local signals for Rx
    signal s_Rx_serial  : std_logic;
    signal s_Rx_byte    : std_logic_vector(7 downto 0);
    signal s_Rx_active  : std_logic;

begin
    -- Connecting testbench signals with UART entity
    -- (Unit Under Test)
    uut_UART_Tx : entity work.UART_Tx
        port map(
            clk_i       => s_clk_100MHz,
            Tx_start_i  => s_Tx_start,
            Tx_byte_i   => s_Tx_byte,
            Tx_serial_o => s_Tx_serial,
            Tx_active_o => s_Tx_active,
            Tx_done_o   => s_Tx_done
        );
        
    uut_UART_Rx : entity work.UART_Rx
        port map(
            clk_i       => s_clk_100MHz,
            Rx_serial_i => s_Rx_serial,
            Rx_byte_o   => s_Rx_byte,
            Rx_active_o => s_Rx_active
        );

    --------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 20 ms loop -- 10 usec of simulation
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    --------------------------------------------------------
    -- Data generation process for Tx
    --------------------------------------------------------
    p_data_gen_Tx : process
    begin
        s_Tx_byte <= b"00101101"; wait for 3.35 ms;
        s_Tx_byte <= b"11010010";
        wait;
    end process p_data_gen_Tx;
    
    --------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------
    p_stimulus : process
    begin
        s_Tx_start <= '0'; wait for 2 ms;
        s_Tx_start <= '1';
        wait;
    end process p_stimulus;
       
end architecture testbench;
