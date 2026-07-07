library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UartController is
	generic(
		ClkRate : integer := 100000000;  --Default 100 MHz
		BaudRate : integer := 115200  --Default 115200 common in UART controllers
	)
	port(
		clk : in std_logic;
		rst_not : in std_logic;

		--external state signals
		--transmitting
		tx_wr_en : in std_logic;
		tx_wr_data : in std_logic_vector(7 downto 0);
		tx_busy : out std_logic;

		--receiving
		rx_rd_en : in std_logic;
		rx_rd_data : out std_logic_vector(7 downto 0);
		rx_valid : out std_logic;

		--Physical wires
		uart_tx : out std_logic;
		uart_rx : in std_logic
	);
end UartController;

architecture arch of UartController is
	
	--Clock division constants
	constant BaudDiv : integer := ClkRate / BaudRate;
	constant HalfBaudDiv : integer := BaudDiv / 2;

	--State machine states
	type TxStateType is (tx_idle, tx_start, tx_data, tx_stop);
	type RxStateType is (rx_idle, rx_start, rx_data, rx_stop);

	--defaults
	signal tx_state : TxStateType := tx_idle;
	signal tx_shift : std_logic_vector(7 downto 0) := (others => '0');
	signal tx_bit_idx : integer range 0 to 7 := 0;
	signal tx_baud_cnt : integer range 0 to BaudDiv - 1 := 0;
	signal tx_out : std_logic := '1';
	signal tx_busy_i : std_logic := '0';

	signal rx_state : RxStateType := rx_idle;
	signal rx_shift : std_logic_vector(7 downto 0) := (others => '0');
	signal rx_data_reg : std_logic_vector(7 downto 0) := (others => '0');
	signal rx_bit_idx : integer range 0 to 7 := 0;
	signal rx_baud_cnt : integer range 0 to BaudDiv - 1 := 0;
	signal rx_valid_i : std_logic := '0';

	--Necessary for CDC synchronization!
	signal rx_sync1 : std_logic := '1';
	signal rx_sync2 : std_logic := '1';
begin

end architecture;