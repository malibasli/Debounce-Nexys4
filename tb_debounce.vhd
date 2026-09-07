library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_debounce is               -- testbench entity boþ olur sadece generic tanýmlanýr 
generic (
c_clkfreq	: integer 	:= 100_000_000;
c_debtime	: integer 	:= 1000;
c_initval	: std_logic	:= '0'
);
end tb_debounce;

architecture Behavioral of tb_debounce is

component debounce is  --- componenti tanýttýk 
generic (
c_clkfreq	: integer := 100_000_000;
c_debtime	: integer := 1000;
c_initval	: std_logic	:= '0'
);
port (
clk			: in std_logic;
signal_i	: in std_logic;
signal_o	: out std_logic
);
end component;

signal clk			: std_logic := '0';
signal signal_i		: std_logic := '0';
signal signal_o		: std_logic;

constant c_clkperiod	: time := 10 ns;  -- fizikseldeki 100mhz clockun periodu 10ns dir

begin

DUT : debounce          -- componenti alt modül olarak çaðýrdýk 
generic map(
c_clkfreq	=> c_clkfreq ,
c_debtime	=> c_debtime ,
c_initval	=> c_initval
)
port map(
clk			=> clk		 ,
signal_i	=> signal_i  ,
signal_o	=> signal_o
);

P_CLKGEN : process begin -- burda sanal clokc oluþturuldu 
clk	<= '0';
wait for c_clkperiod/2;
clk	<= '1';
wait for c_clkperiod/2;
end process;

P_STIMULI : process begin -- buradak input sinyali belli sürelerle deðiþtirelerek 1ms yi geçince outputu deðiþtirip deðitrmediði kontrol ediliyor

signal_i	<= '0';
wait for 2 ms;

signal_i	<= '1';
wait for 100 us;
signal_i	<= '0';
wait for 200 us;
signal_i	<= '1';
wait for 100 us;
signal_i	<= '0';
wait for 100 us;
signal_i	<= '1';
wait for 800 us;
signal_i	<= '0';
wait for 50 us;
signal_i	<= '1';
wait for 3 ms;

signal_i 	<= '0';
wait for 100 us;
signal_i 	<= '1';
wait for 200 us;
signal_i 	<= '0';
wait for 950 us;
signal_i 	<= '1';
wait for 150 us;
signal_i 	<= '0';
wait for 2 ms;

assert false     -- bu kýsmý yazarak simulasayon yaparken direk baþlat diyoruz bitince duruyor 
report "SIM DONE"
severity failure;

end process;


end Behavioral;