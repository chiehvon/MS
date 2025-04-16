library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity MUX21_GENERIC is
generic (
  NBIT      : integer := NumBit;
  DELAY_MUX : time    := TP_MUX
);
port (
  A : in std_logic_vector(NBIT - 1 downto 0);
  B : in std_logic_vector(NBIT - 1 downto 0);
  S : in std_logic;
  Y : out std_logic_vector(NBIT - 1 downto 0)
);
end MUX21_GENERIC;

architecture ARCHITECTURAL of MUX21_GENERIC is
component MUX21 is
  generic (DELAY : time); -- 添加泛型参数
  port (
    A : in std_logic;
    B : in std_logic;
    S : in std_logic;
    Y : out std_logic
  );
end component;

begin
U : for i in 0 to NBIT - 1 generate
  MUX21_G : MUX21
  generic map(DELAY => DELAY_MUX) -- 传递延迟参数
  port map
  (
    A => A(i),
    B => B(i),
    S => S,
    Y => Y(i)
  );
end generate;
end ARCHITECTURAL;

configuration CFG_MUX21_ARCHITECTURAL of MUX21_GENERIC is
for ARCHITECTURAL
end for;
end CFG_MUX21_ARCHITECTURAL;
