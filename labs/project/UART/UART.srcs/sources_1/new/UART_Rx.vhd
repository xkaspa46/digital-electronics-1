------------------------------------------------------------
-- Design of UART Reciever
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
-- Entity declaration for UART Reciever
------------------------------------------------------------
entity UART_Rx is
    port (
    clk_i           : in  std_logic;
    rst_i           : in  std_logic;
    Rx_serial_i     : in  std_logic;
    Rx_byte_o       : out std_logic_vector (7 downto 0);
    Rx_active_o     : out std_logic 
    );
    
end UART_Rx;

------------------------------------------------------------
-- Architecture body for UART Reciever
------------------------------------------------------------
architecture Behavioral of UART_Rx is
    type t_Rx is (Rx_start_bit_s, Rx_stop_bit_s, Idle_s, Rx_data_s);
    signal s_Rx : t_Rx := Idle_s;
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
    
    p_UART_Rx: process(clk_i)
    begin
        if rising_edge(clk_i) then
            case s_Rx is
                when Idle_s =>
                    Rx_byte_o   <= "00000000";
                    Rx_active_o <= '0';
            
                -- start bit = '0'
                when Rx_start_bit_s =>
                    Rx_active_o <= '1';
                    
                when Rx_data_s =>
                    -- Rx_serial_i <= Rx_Byte_o;
                
                -- stop bit = '1'
                when Rx_stop_bit_s =>
                    Rx_active_o <= '0';
                
                when others =>
                    s_Rx <= Idle_s;
                    
            end case;
          end if;
    end process;
end Behavioral;