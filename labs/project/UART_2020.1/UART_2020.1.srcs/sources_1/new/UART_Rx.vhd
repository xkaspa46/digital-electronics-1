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
    
    signal s_en      : std_logic;
    signal s_Rx      : t_Rx := Idle_s;
    signal s_Rx_byte : std_logic_vector (7 downto 0);
    signal s_clock   : integer range 0 to 10417 := 0;
    signal s_bit     : integer range 0 to 7 := 0;
    
    constant c_ZERO  : integer := 0;
    constant c_BIT   : integer := 10417;
      
begin

--------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates 
    clk_en : entity work.clock_enable
        generic map(
            g_MAX => 10417
        )
        port map(
            clk   => clk_i,
            reset => '0',
            ce_o  => s_en
        );
    
    p_UART_Rx: process(clk_i)
    begin
        if rising_edge(clk_i) then
            case s_Rx is
                when Idle_s =>
                    Rx_active_o <= '0';
                    Rx_byte_o   <= "00000000";
                    s_clock     <= c_ZERO;
                    s_bit       <= 0;
                    
                    if Rx_serial_i = '0' then
                        s_Rx      <= Rx_start_bit_s;
                    else
                        s_Rx      <= Idle_s;
                    end if;
            
                -- start bit = '0'
                when Rx_start_bit_s =>
                    Rx_active_o <= '1';
                    
                    if s_clock < c_BIT/2 then
                        if Rx_serial_i = '0' then
                            s_clock <= c_ZERO;
                            s_Rx    <= Rx_data_s;
                        else
                            s_Rx <= Idle_s;
                        end if;
                    else
                        s_clock <= s_clock + 1;
                        s_Rx    <= Rx_start_bit_s;
                    end if; 
                        
                when Rx_data_s =>
                    if s_clock < c_BIT then
                        s_clock <= s_clock + 1;
                        s_Rx    <= Idle_s;
                    else
                        s_clock          <= c_ZERO;
                        s_Rx_byte(s_bit) <= Rx_serial_i;
                        
                        if s_bit < 7 then
                            s_bit <= s_bit + 1;
                            s_Rx  <= Rx_data_s;
                        else
                            s_bit <= 0;
                            s_Rx  <= Rx_stop_bit_s;
                        end if;
                    end if;

                -- stop bit = '1'
                when Rx_stop_bit_s =>
                    Rx_active_o <= '0';
                    
                    if s_clock < c_BIT then
                        s_clock <= s_clock + 1;
                        s_Rx    <= Rx_stop_bit_s;
                    else
                        s_clock   <= c_ZERO;
                        s_Rx      <= Idle_s;
                    end if;
                
                when others =>
                    s_Rx <= Idle_s;
                    
            end case;
          end if;
    end process;
end Behavioral;