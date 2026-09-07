library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is                                           -- dýþ dünya pinleri ve generic tanýmlamasý
generic (                                               -- dýþ dünya pinleri ve generic tanýmlamasý
c_clkfreq	: integer := 100_000_000;                   -- dýþ dünya pinleri ve generic tanýmlamasý
c_debtime	: integer := 1000;                          -- dýþ dünya pinleri ve generic tanýmlamasý
c_initval	: std_logic	:= '0'                          -- dýþ dünya pinleri ve generic tanýmlamasý
);                                                      -- dýþ dünya pinleri ve generic tanýmlamasý
port (                                                  -- dýþ dünya pinleri ve generic tanýmlamasý
clk			: in std_logic;                             -- dýþ dünya pinleri ve generic tanýmlamasý
sw_i		: in std_logic_vector (1 downto 0);         -- dýþ dünya pinleri ve generic tanýmlamasý
button_i	: in std_logic;                             -- dýþ dünya pinleri ve generic tanýmlamasý
led_o		: out std_logic_vector (15 downto 0)        -- dýþ dünya pinleri ve generic tanýmlamasý
);                                                      -- dýþ dünya pinleri ve generic tanýmlamasý
end top;                                                -- dýþ dünya pinleri ve generic tanýmlamasý

architecture Behavioral of top is

component debounce is                                     -- componenti tanýttýk top modüle 
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

signal counter_sw1	: std_logic_vector (7 downto 0) := (others => '0'); -- ledlere yansýtacaðýmýz 0 dan 1 e geçiþleri sayacak olan sinyaller
signal counter_sw2	: std_logic_vector (7 downto 0) := (others => '0');

signal sw1_previus	: std_logic := '0';
signal sw2_previus	: std_logic := '0';
signal sw1_deb		: std_logic := '0';

signal rise_edge_sw1: std_logic := '0';
signal rise_edge_sw2: std_logic := '0';

begin

debounce_i : debounce                           -- dýþ dünyadaki yani buradaki pinlere componentte eþleþtirerek   
generic map(                                    -- componentteki fonskiyonu kullandýk.
c_clkfreq	=> c_clkfreq,
c_debtime	=> c_debtime,
c_initval	=> c_initval
)
port map(
clk			=> clk,
signal_i	=> sw_i(0), -- giriþine switch1 i verdik
signal_o	=> sw1_deb --- çýkýþýný bu siyalle kontrol ettik 
);

process (clk) begin
if (rising_edge(clk)) then

	sw1_previus	<= sw1_deb; -- clok vurduðu an saðdaki deðer sola geçer ( geçmiþ durumun hafizaya alýnmasý )
	sw2_previus	<= sw_i(1);
	
	if (sw1_deb = '1' and sw1_previus = '0') then      --- bu bloklar sw lere risign edge gelip gelmediðine bakar
		rise_edge_sw1	<= '1';                        --- bu bloklar sw lere risign edge gelip gelmediðine bakar
	else                                               --- bu bloklar sw lere risign edge gelip gelmediðine bakar
		rise_edge_sw1	<= '0';                        --- bu bloklar sw lere risign edge gelip gelmediðine bakar
	end if;                                            --- bu bloklar sw lere risign edge gelip gelmediðine bakar
	                                                   --- bu bloklar sw lere risign edge gelip gelmediðine bakar
	if (sw_i(1) = '1' and sw2_previus = '0') then      --- bu bloklar sw lere risign edge gelip gelmediðine bakar
		rise_edge_sw2	<= '1';                        --- bu bloklar sw lere risign edge gelip gelmediðine bakar
	else                                               --- bu bloklar sw lere risign edge gelip gelmediðine bakar
		rise_edge_sw2	<= '0';                        --- bu bloklar sw lere risign edge gelip gelmediðine bakar
	end if;	                                           --- bu bloklar sw lere risign edge gelip gelmediðine bakar
	
	if (rise_edge_sw1 = '1') then                      -- bu bloklar ise rising edge geldiyse counterlerini sayar
		counter_sw1	<= counter_sw1 + 1;                -- bu bloklar ise rising edge geldiyse counterlerini sayar
	end if;                                            -- bu bloklar ise rising edge geldiyse counterlerini sayar
	                                                   -- bu bloklar ise rising edge geldiyse counterlerini sayar
	if (rise_edge_sw2 = '1') then                      -- bu bloklar ise rising edge geldiyse counterlerini sayar
		counter_sw2	<= counter_sw2 + 1;                -- bu bloklar ise rising edge geldiyse counterlerini sayar
	end if;	                                           -- bu bloklar ise rising edge geldiyse counterlerini sayar
	
	if (button_i = '1') then                           -- burasý da butona basýlýp reset atarsa counterleri sýfýrlýyor
		counter_sw1	<= (others => '0');                -- burasý da butona basýlýp reset atarsa counterleri sýfýrlýyor
		counter_sw2	<= x"00";                          -- burasý da butona basýlýp reset atarsa counterleri sýfýrlýyor
	end if;                                            -- burasý da butona basýlýp reset atarsa counterleri sýfýrlýyor

end if;
end process;

led_o(7 downto 0)	<= counter_sw1;                    --burada counterlýn kaç saydýðýný ledlere atayarak bakýyoruz
led_o(15 downto 8)	<= counter_sw2;                    --burada counterlýn kaç saydýðýný ledlere atayarak bakýyoruz

end Behavioral;