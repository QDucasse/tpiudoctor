library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tpiu_to_axi is
 Port (
  -- Trace data input
  IN_DATA : in std_logic_vector (31 downto 0);

  --  AXI4-Stream ouptut
  ACLK : in std_logic;
  ARESETN : in std_logic;
  TVALID  : out std_logic;
  TREADY  : in std_logic;
  TDATA   : out std_logic_vector (31 downto 0);
  TLAST   : out std_logic;

  -- Nothing function, only debug
  DROPPED : out std_logic
);
end tpiu_to_axi;


architecture Behavioral of tpiu_to_axi is

    constant SYNCH_PACKET       : std_logic_vector(31 downto 0) := X"7FFFFFFF";
    constant HALF_SYNCH_PACKET  : std_logic_vector(31 downto 0) := X"7FFF7FFF";

    signal last_synch           : std_logic := '0';
    signal tvalid_reg           : std_logic := '0';
    signal tdata_reg            : std_logic_vector(31 downto 0) := (others => '0');
    signal tlast_reg            : std_logic := '0';
    signal dropped_reg          : std_logic := '0';

begin

    TVALID <= tvalid_reg;
    TDATA  <= tdata_reg;
    TLAST  <= tlast_reg;
    DROPPED <= dropped_reg;

    process (ACLK)
    begin
        if rising_edge(ACLK) then
            if ARESETN = '0' then
                last_synch   <= '0';
                tvalid_reg   <= '0';
                tdata_reg    <= (others => '0');
                tlast_reg    <= '0';
                dropped_reg  <= '0';
            else
                if TREADY = '1' then
                    if IN_DATA = SYNCH_PACKET and last_synch = '0' then
                        tdata_reg  <= IN_DATA;
                        tvalid_reg <= '1';
                        tlast_reg  <= '0'; -- Synchronization packet is not end-of-stream
                        last_synch <= '1';
                    elsif IN_DATA /= SYNCH_PACKET and IN_DATA /= HALF_SYNCH_PACKET then
                        tdata_reg  <= IN_DATA;
                        tvalid_reg <= '1';
                        tlast_reg  <= '0'; -- Define if you have an actual packet boundary
                        last_synch <= '0';
                    else
                        dropped_reg <= '1'; -- optional debug flag
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;

