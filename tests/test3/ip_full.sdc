# Clocks
create_clock -name clk_a -period 10 [get_ports din_a[0]]
create_clock -name clk_b -period 5 [get_ports din_b[0]]
create_clock -name async_clk -period 12 [get_ports din_a[7]]

# Input delays
set_input_delay -clock clk_a 2 [get_ports din_a[0]]
set_input_delay -clock clk_b 1 [get_ports din_b[0]]

# Output delays
set_output_delay -clock clk_a 1 [get_ports dout_a[0]]
set_output_delay -clock clk_b 0.5 [get_ports dout_b[0]]

# Max transition
set_max_transition 0.8 [get_ports dout_a[0]]

# Ready signal delay
set_output_delay -clock clk_b 0.1 [get_ports ready]
