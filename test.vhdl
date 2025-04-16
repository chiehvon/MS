library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programmable_timer is
  port (
    CLOCK_50 : in std_logic; -- 50 MHz clock signal
    KEY      : in std_logic_vector(2 downto 0);
    SW       : in std_logic_vector(2 downto 0);
    HEX2     : out std_logic_vector(6 downto 0);
    HEX1     : out std_logic_vector(6 downto 0);
    HEX0     : out std_logic_vector(6 downto 0)
  );
end programmable_timer;

architecture behavior of programmable_timer is --Set different counters.
  signal minute_counter : integer range 0 to 7  := 0;
  signal second_counter : integer range 0 to 59 := 0;
  signal clk_divider    : integer               := 0;
  constant MAX_COUNT    : integer               := 50_000_000;
  signal running        : std_logic             := '0';

  -- Encoding function for digit/character to 7-segment display
  function to_seven_seg (digit : integer) return std_logic_vector is
    type seven_seg_array is array (0 to 15) of std_logic_vector(6 downto 0);
    constant seven_seg_map : seven_seg_array :=
    ("1000000",
    "1111001",
    "0100100",
    "0110000",
    "0011001",
    "0010010",
    "0000010",
    "1111000",
    "0000000",
    "0011000",
    "0001000",
    "0000011",
    "1000110",
    "0100001",
    "0000110",
    "0001110");
  begin
    return seven_seg_map(digit);
  end to_seven_seg;

begin
  process (CLOCK_50, KEY)
  begin
    if KEY(0) = '0' then
      -- When the reset signal is active, clear the counter.
      minute_counter <= 0;
      second_counter <= 0;
      clk_divider    <= 0;
      running        <= '0';
    elsif rising_edge(CLOCK_50) then
      -- When the load signal is active, set the initial minute value.
      if KEY(1) = '0' then
        minute_counter <= to_integer(unsigned(SW));
        second_counter <= 0;
      end if;

      -- Countdown logic
      if running = '1' then
        if clk_divider < MAX_COUNT then
          clk_divider <= clk_divider + 1;
        else
          clk_divider <= 0;
          -- Countdown every second
          if second_counter > 0 then
            second_counter <= second_counter - 1;
          else
            if minute_counter > 0 then
              minute_counter <= minute_counter - 1;
              second_counter <= 59;
            else
              running <= '0';
            end if;
          end if;
        end if;
      end if;

      -- Start the timer
      if KEY(2) = '0' and minute_counter /= 0 then
        running <= '1';
      end if;
    end if;
  end process;

  -- Display the current remaining minutes and seconds.
  HEX2 <= to_seven_seg(minute_counter);
  HEX1 <= to_seven_seg(second_counter / 10);
  HEX0 <= to_seven_seg(second_counter mod 10);

end behavior;
