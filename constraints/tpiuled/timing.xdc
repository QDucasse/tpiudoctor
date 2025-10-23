# Define generated clock trace_clk_out from the primary clock (pl_clk0 is at 250MHz, trace_clk_out 125MHz)
create_generated_clock -name tpiuled_i/zynq_ps_pl/inst/trace_clk_out -source [get_pins {tpiuled_i/zynq_ps_pl/inst/PS8_i/PLCLK[0]}] -divide_by 2 [get_pins tpiuled_i/zynq_ps_pl/inst/trace_clk_out_reg/Q]

# Remove timing restrictions for the LED ports
set_false_path -to [get_ports Dout_0]
set_false_path -to [get_ports Dout_1]
