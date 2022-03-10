library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity t_ff_rst is
    Port ( clk   : in STD_LOGIC;
           rst   : in STD_LOGIC;
           t     : in STD_LOGIC;
           q     : out STD_LOGIC;
           q_bar : out STD_LOGIC);
end t_ff_rst;

architecture Behavioral of t_ff_rst is
    signal s_q : std_logic;
begin
    p_t_ff_rst : process(clk)
    begin
        if rising_edge(clk) then  -- Synchronous process
            -- USE HIGH-ACTIVE RESET HERE
            if (rst='1') then
                s_q    <='0';
            elsif (t='0') then
                s_q    <= s_q;
            else
                s_q    <= not s_q;                
            end if;
        end if;
    end process p_t_ff_rst;
    q     <= s_q;
    q_bar <= not s_q;
end architecture Behavioral;

