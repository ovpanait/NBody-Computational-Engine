library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity r_st3 is
	generic(
		DATA_W:           integer := 64;
		BYTES_N:				integer := 8
	);
	port(
		clk:				in std_logic;
		reset:			in std_logic;
		en_in:			in std_logic;
		
		diff_x:			in unsigned(DATA_W - 1 downto 0);
		diff_y:			in unsigned(DATA_W - 1 downto 0);
		diff_x_sq:		in unsigned(DATA_W - 1 downto 0);
		diff_y_sq:		in unsigned(DATA_W - 1 downto 0);
		
		r:					out unsigned(DATA_W - 1 downto 0);
		diff_x_buf:		out unsigned(DATA_W - 1 downto 0);
		diff_y_buf:		out unsigned(DATA_W - 1 downto 0);
		en_out:			out std_logic
	);
end r_st3;

architecture arch of r_st3 is
	signal diff_x_reg, diff_x_next:	unsigned(DATA_W - 1 downto 0);
	signal diff_y_reg, diff_y_next:	unsigned(DATA_W - 1 downto 0);
begin
	process(clk, reset)
	begin
		if reset = '0' then
			diff_x_reg <= (others => '0');
			diff_y_reg <= (others => '0');
		elsif (clk'event and clk='1') then
			diff_x_reg <= diff_x_next;
			diff_y_reg <= diff_y_next;
		end if;
	end process;

-- Next state logic
	process(en_in, diff_x, diff_y)
	begin
		if en_in = '1' then
			diff_x_next <= diff_x;
			diff_y_next <= diff_y;
		else
			diff_x_next <= (others => '0');
			diff_y_next <= (others => '0');
		end if;
	end process;
	
	calc_r: work.fp_add
		port map(clk => clk, reset => reset, en_in => en_in, a => diff_x_sq, b => diff_y_sq, result => r, en_out => en_out);
		
	diff_x_buf <= diff_x_reg;
	diff_y_buf <= diff_y_reg;
end arch;
