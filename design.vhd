library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity goertzel_filter is
    generic (
        coef : signed(19 downto 0) := to_signed(19447, 20);
        coef_div : signed(19 downto 0) := to_signed(10000, 20)
    );
    port (
        input_signal : in unsigned (11 downto 0);
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        magnitude : out signed(19 downto 0)
    );
end entity goertzel_filter;

architecture behavioural of goertzel_filter is
    signal q0, q1, q2 : signed(19 downto 0);
    signal x : signed(11 downto 0);
    signal result : signed(19 downto 0);
begin
    process (clk, rst)
    begin
        if rst = '1' then
        
            q0 <= (others => '0');
            q1 <= (others => '0');
            q2 <= (others => '0');
            result <= (others => '0');
            
        elsif rising_edge(clk) then
        
            x <= signed(resize(input_signal, x'length));
            q0 <= x + resize(coef * q1 / coef_div, q0'length) - q2;
            q2 <= q1;
            q1 <= q0;
            
            --Optimized Goertzel
            result <= resize(q1 * q1 + q2 * q2 - resize(coef * q2 * q1 / coef_div, result'length), result'length);
            
        end if;
    end process;

    magnitude <= result;
end architecture behavioural;
