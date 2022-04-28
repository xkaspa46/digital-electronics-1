------------------------------------------------------------
--
-- Generates clock enable signal.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2019-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library ieee;               -- Standard library
use ieee.std_logic_1164.all;-- Package for data types and logic operations
use ieee.numeric_std.all;   -- Package for arithmetic operations

------------------------------------------------------------
-- Entity declaration for clock enable
------------------------------------------------------------
entity clock_enable is
    generic(
        g_MAX : natural := 10  -- Number of clk pulses to
                               -- generate one enable signal
                               -- period
    );  -- Note that there IS a semicolon between generic 
        -- and port sections
    port(
        clk   : in  std_logic; -- Main clock
        reset : in  std_logic; -- Synchronous reset
        ce_o  : out std_logic  -- Clock enable pulse signal
    );
end entity clock_enable;

------------------------------------------------------------
-- Architecture body for clock enable
------------------------------------------------------------
architecture Behavioral of clock_enable is

    -- Local counter
    signal s_cnt_local : natural;

begin
    --------------------------------------------------------
    -- p_clk_ena:
    -- Generate clock enable signal. By default, enable signal
    -- is low and generated pulse is always one clock long.
    --------------------------------------------------------
    p_clk_ena : process(clk)
    begin
        if rising_edge(clk) then    -- Synchronous process

            if (reset = '1') then   -- High active reset
                s_cnt_local <= 0;   -- Clear local counter
                ce_o        <= '0'; -- Set output to low

            -- Test number of clock periods
            elsif (s_cnt_local >= (g_MAX - 1)) then
                s_cnt_local <= 0;   -- Clear local counter
                ce_o        <= '1'; -- Generate clock enable pulse

            else
                s_cnt_local <= s_cnt_local + 1;
                ce_o        <= '0';
            end if;
        end if;
    end process p_clk_ena;

end architecture Behavioral;
