------------------------------------------------------------
-- Design of UART Transmitter
-- 14.04.2022
-- Our group

-- Clock in Nexys A7-50T - 100 MHz
-- g_MAX = (frequency of clock on board)/(baud)
-- Our example: 100MHz Clock frequency, 9600 Baud
-- g_MAX = (100000000/9600) = 10417
------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

------------------------------------------------------------
-- Entity declaration for UART Transmitter
------------------------------------------------------------
entity UART_Tx is
    port (
    clk_i           : in  std_logic;
    rst_i           : in  std_logic;
    Tx_byte_i       : in  std_logic_vector (7 downto 0);
    Tx_serial_o     : out std_logic;
    Tx_active_o     : out std_logic;
    Tx_done_o       : out std_logic
    );
    
end UART_Tx;

------------------------------------------------------------
-- Architecture body for UART Transmitter
------------------------------------------------------------
architecture Behavioral of UART_Tx is
    type t_Tx is (Tx_start_bit_s, Tx_stop_bit_s, Idle_s, Tx_data_s);
    signal s_Tx : t_Tx := Idle_s;
begin

--------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates 
    clk_en : entity work.clock_enable
        generic map(
            g_MAX => 10417
        )
        port map(
            clk   => clk_i,
            reset => rst_i
        );
     
    p_UART_Tx: process(clk_i)
    begin
        if rising_edge(clk_i) then
            case s_Tx is
                when Idle_s =>
                    Tx_active_o <= '0';
                    Tx_serial_o <= '0';
            
                -- start bit = '0'
                when Tx_start_bit_s =>
                    Tx_active_o <= '1';
                    Tx_serial_o <= '0';
                    
                when Tx_data_s =>
                    -- Tx_serial_o <= Tx_Byte_i;
                
                -- stop bit = '1'
                when Tx_stop_bit_s =>
                    Tx_active_o <= '0';
                    Tx_serial_o <= '1';
                
                when others =>
                    s_Tx <= Idle_s;
                    
            end case;
          end if;
    end process;
end Behavioral;
