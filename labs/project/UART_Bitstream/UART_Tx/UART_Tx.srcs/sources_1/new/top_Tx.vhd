------------------------------------------------------------
-- Design of top for Transmitter
-- 28.04.2022
-- Tomas Kristek, Tomas Kaspar, Dusan Kratochvil
------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------
-- Entity declaration of top for Transmitter
------------------------------------------------------------
entity top_Tx is
    Port ( CLK100MHZ : in  STD_LOGIC;
           SW        : in  STD_LOGIC_VECTOR (7 downto 0);
           SW15      : in  STD_LOGIC;
           LED       : out STD_LOGIC_VECTOR (7 downto 0);
           LED15     : out STD_LOGIC;
           JA1       : out STD_LOGIC;
           LED17_R   : out STD_LOGIC;
           LED16_B   : out STD_LOGIC);
end top_Tx;

------------------------------------------------------------
-- Architecture body of top for Transmitter
------------------------------------------------------------
architecture Behavioral of top_Tx is
begin
    UART_Tx : entity work.UART_Tx
        port map(
            clk_i       => CLK100MHZ,
            Tx_start_i  => SW15,
            Tx_byte_i   => SW,
            Tx_serial_o => JA1,
            Tx_active_o => LED17_R,
            Tx_done_o   => LED16_B
        );

    LED(7 downto 0) <= SW;
    LED15           <= SW15;
end Behavioral;
