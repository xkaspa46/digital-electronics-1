------------------------------------------------------------
-- Design of top for Reciever
-- 28.04.2022
-- Tomas Kristek, Tomas Kaspar, Dusan Kratochvil
------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------
-- Entity declaration of top for Reciever
------------------------------------------------------------
entity top_Rx is
    Port ( CLK100MHZ : in  STD_LOGIC;
           BTNC      : in  STD_LOGIC;
           JD1       : in  STD_LOGIC;
           LED       : out STD_LOGIC_VECTOR (7 downto 0);
           LED17_R   : out STD_LOGIC);
end top_Rx;

------------------------------------------------------------
-- Architecture body of top for Reciever
------------------------------------------------------------
architecture Behavioral of top_Rx is
begin
     UART_Rx : entity work.UART_Rx
        port map(
            clk_i       => CLK100MHZ,
            rst_i       => BTNC,
            Rx_serial_i => JD1,
            Rx_byte_o   => LED,
            Rx_active_o => LED17_R
        );
end Behavioral;
