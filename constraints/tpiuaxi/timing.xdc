# Define generated clock trace_clk_out from the primary clock (pl_clk0 is at 250MHz, trace_clk_out 125MHz)
create_generated_clock -name tpiuaxi_i/zynq_ps_pl/inst/trace_clk_out -source [get_pins {tpiuaxi_i/zynq_ultra_ps_pl/inst/PS8_i/PLCLK[0]}] -divide_by 2 [get_pins tpiuaxi_i/zynq_ultra_ps_pl/inst/trace_clk_out_reg/Q]

# Define asynchronous clocks between AXI and TPIU
set_clock_groups -asynchronous -group [get_clocks clk_pl_0] -group [get_clocks clk_pl_1]