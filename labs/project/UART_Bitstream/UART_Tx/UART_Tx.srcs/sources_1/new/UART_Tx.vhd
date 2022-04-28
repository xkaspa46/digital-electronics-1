------------------------------------------------------------
-- Design of UART Transmitter
-- 14.04.2022
-- Tomas Kristek, Tomas Kaspar, Dusan Kratochvil

-- Clock in Nexys A7-50T - 100 MHz
-- g_MAX = (frequency of clock on board)/(baud)
-- Our values for setting up: 100MHz Clock frequency, 9600 Baud
-- g_MAX = (100000000/9600) = 10417
-- For our example, we needed to divide 10417 by 2 for 9600 Baud
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
    Tx_start_i      : in  std_logic;
    Tx_byte_i       : in  std_logic_vector (7 downto 0);
    Tx_serial_o     : out std_logic := '1'; -- base 1
    Tx_active_o     : out std_logic;
    Tx_done_o       : out std_logic
    );
    
end UART_Tx;

------------------------------------------------------------
-- Architecture body for UART Transmitter
------------------------------------------------------------
architecture Behavioral of UART_Tx is

    -- Define the states
    type t_Tx is (Idle_s, Tx_start_bit_s, Tx_data_s, Tx_stop_bit_s, Tx_done_s);
    
    -- Local signals for Transmitter
    signal s_Tx      : t_Tx := Idle_s;
    signal s_en      : std_logic := '0';
    signal s_Tx_data : std_logic_vector (7 downto 0) := "00000000";
    signal s_cnt     : unsigned(0 downto 0) := b"0";
    signal s_bit     : integer range 0 to 7 := 0;
    
    -- Local constants for Transmitter
    constant c_ZERO  : unsigned := b"0";
    constant c_BIT   : unsigned := b"1";
    
begin

--------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates 
    clk_en : entity work.clock_enable
        generic map(
            g_MAX => 5208
        )
        port map(
            clk   => clk_i,
            reset => '0',
            ce_o  => s_en
        );
--------------------------------------------------------

--------------------------------------------------------
    -- Whole process for UART Transmitter
    p_UART_Tx: process(clk_i)
    begin
        if rising_edge(clk_i) and s_en = '1' then         
            case s_Tx is
                
                when Idle_s =>
                    Tx_active_o <= '0';
                    Tx_serial_o <= '1';
                    Tx_done_o   <= '0';
                    s_cnt       <= c_ZERO;
                    s_bit       <= 0;
                    
                    if Tx_start_i = '1' then
                        s_Tx_data <= Tx_byte_i;
                        s_Tx      <= Tx_start_bit_s;
                    else
                        s_Tx      <= Idle_s;
                    end if;
            
                -- start bit = '0'
                when Tx_start_bit_s =>
                    Tx_active_o <= '1';
                    Tx_serial_o <= '0';
                        
                    if s_cnt < c_BIT then
                        s_cnt <= s_cnt + 1;
                        s_Tx  <= Tx_start_bit_s;
                    else
                        s_cnt <= c_ZERO;
                        s_Tx  <= Tx_data_s;
                    end if;
                    
                when Tx_data_s =>
                    Tx_serial_o <= s_Tx_data(s_bit);
                        
                    if s_cnt < c_BIT then
                        s_cnt <= s_cnt + 1;
                        s_Tx  <= Tx_data_s;
                    else
                        s_cnt <= c_ZERO;
                            
                        if s_bit < 7 then
                            s_bit <= s_bit + 1;
                            s_Tx  <= Tx_data_s;
                        else
                            s_bit <= 0;
                            s_Tx  <= Tx_stop_bit_s;
                        end if;                           
                    end if;
                
                -- stop bit = '1'
                when Tx_stop_bit_s =>
                    Tx_serial_o <= '1';
                        
                    if s_cnt < c_BIT then
                        s_cnt <= s_cnt + 1;
                        s_Tx  <= Tx_stop_bit_s;
                    else
                        s_cnt <= c_ZERO;
                        s_Tx  <= Tx_done_s;
                    end if;
                    
                when Tx_done_s =>
                    Tx_active_o <= '0';
                    Tx_done_o   <= '1';
                    s_Tx        <= Idle_s;
                
                when others =>
                    s_Tx <= Idle_s;
                           
            end case;
        end if;    
    end process p_UART_Tx;
--------------------------------------------------------

end Behavioral;
