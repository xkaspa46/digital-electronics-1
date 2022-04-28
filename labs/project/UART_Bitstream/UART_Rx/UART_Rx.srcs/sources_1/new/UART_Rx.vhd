------------------------------------------------------------
-- Design of UART Reciever
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

    -- Define the states
    type t_Rx is (Idle_s, Rx_start_bit_s, Rx_data_s, Rx_stop_bit_s, Rx_done_s);
    
    -- Local signals for Reciever
    signal s_Rx      : t_Rx := Idle_s;
    signal s_en      : std_logic := '0';
    signal s_Rx_data : std_logic := '1';
    signal s_Rx_byte : std_logic_vector (7 downto 0) := b"00000000";
    signal s_cnt     : unsigned(0 downto 0) := "0";
    signal s_bit     : integer range 0 to 7 :=0;
    
    -- Local constants for Reciever
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
            reset => rst_i,
            ce_o  => s_en
        );
--------------------------------------------------------   

--------------------------------------------------------  
    -- Data conversion from input Rx_serial to
    -- internal signal Rx_data
    p_DATACON : process(clk_i)
    begin
        if rising_edge(clk_i) and s_en = '1' then
            s_Rx_data <= Rx_serial_i;
        end if;
    end process p_DATACON;
--------------------------------------------------------  

--------------------------------------------------------  
    -- Whole process for UART Transmitter    
    p_UART_Rx: process(clk_i)
    begin
        if rising_edge(clk_i) then
        
            if rst_i = '1' then
                Rx_active_o <= '0';
                s_cnt       <= c_ZERO;
                s_bit       <= 0;
                s_Rx_byte   <= "00000000";
                s_Rx        <= Idle_s;
            elsif s_en = '1' then
                s_Rx <= Idle_s;
                
                case s_Rx is
            
                    when Idle_s =>
                        Rx_active_o <= '0';
                        s_cnt       <= c_ZERO;
                        s_bit       <= 0;
                    
                        if s_Rx_data = '0' then
                            s_Rx        <= Rx_start_bit_s;
                            Rx_active_o <= '1';
                            s_cnt       <= s_cnt + 1;
                        else
                            s_Rx <= Idle_s;
                        end if;
            
                    -- start bit = '0'
                    when Rx_start_bit_s =>
                        if s_cnt < c_BIT then
                            s_cnt <= s_cnt + 1;
                            s_Rx  <= Rx_start_bit_s;
                        else
                            s_Rx  <= Rx_data_s;
                            s_cnt <= c_ZERO;
                        end if; 
                        
                    when Rx_data_s =>
                        if s_cnt < c_BIT then
                            s_cnt <= s_cnt + 1;
                            s_Rx  <= Rx_data_s;
                        else
                            s_cnt            <= c_ZERO;
                            s_Rx_byte(s_bit) <= s_Rx_data;
                        
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
                        if s_cnt < c_BIT then
                            s_cnt <= s_cnt + 1;
                            s_Rx  <= Rx_stop_bit_s;
                        else
                            s_cnt <= c_ZERO;
                            s_Rx  <= Rx_done_s;
                        end if;
                    
                    when Rx_done_s =>
                        Rx_active_o <= '0';
                        s_Rx        <= Idle_s;
                    
                    when others =>
                        s_Rx <= Idle_s;
                    
                end case;
            end if;
        end if;
    end process p_UART_Rx;
    Rx_byte_o <= s_Rx_byte;
--------------------------------------------------------

end Behavioral;