# Clock definition
create_clock -name clk -period 10 [get_ports din[0]]

# Input delay
set_input_delay -clock clk 2 [get_ports din[0]]

# Output delay
set_output_delay -clock clk 1 [get_ports dout[0]]
