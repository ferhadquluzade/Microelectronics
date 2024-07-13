library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_goertzel_filter is
end entity tb_goertzel_filter;

architecture tb_arch of tb_goertzel_filter is
    -- Constants for file paths and scaling factors
    constant INPUT_FILE_PATH : string := "input_signal.txt";
    constant EXPECTED_FILE_PATH : string := "expected_magnitude.txt";

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal input_signal : std_logic_vector(11 downto 0);
    signal magnitude : std_logic_vector(19 downto 0);
    signal expected_magnitude : std_logic_vector(19 downto 0);

    signal input_signal_unsigned : unsigned(11 downto 0);
    signal magnitude_signed : signed(19 downto 0);

    file input_signal_file : text open read_mode is INPUT_FILE_PATH;
    file expected_magnitude_file : text open read_mode is EXPECTED_FILE_PATH;
begin
    -- Clock process
    process
    begin
        wait for 10 ns;
        clk <= not clk;
    end process;

    -- Read input signal and expected magnitude
    process
        variable input_line : line;
        variable expected_line : line;
        variable input_value : integer;
        variable expected_value : integer;
    begin
        while not endfile(input_signal_file) loop
            readline(input_signal_file, input_line);
            read(input_line, input_value);
            input_signal <= std_logic_vector(to_unsigned(input_value, input_signal'length));
            input_signal_unsigned <= to_unsigned(input_value, input_signal_unsigned'length);
            wait until rising_edge(clk);
        end loop;

        while not endfile(expected_magnitude_file) loop
            readline(expected_magnitude_file, expected_line);
            read(expected_line, expected_value);
            expected_magnitude <= std_logic_vector(to_signed(expected_value, magnitude'length));
            wait until rising_edge(clk);
        end loop;

        wait;
    end process;

    -- Instantiate Goertzel filter
    goertzel_inst : entity work.goertzel_filter
        port map (
            clk => clk,
            rst => rst,
            input_signal => input_signal_unsigned,
            magnitude => magnitude_signed
        );

    -- Compare output with expected magnitude
    process
    begin
        -- Wait for filter to settle
        wait for 100 ns;

        -- Compare magnitudes
        assert std_logic_vector(magnitude_signed) = expected_magnitude
            report "Mismatch between calculated and expected magnitude!"
            severity error;
            
         assert false report "Test done." severity note;

        wait;
    end process;

end architecture tb_arch;
