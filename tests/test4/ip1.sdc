# SDC constraints for IP1 (FIFO Controller)

# Create clock constraint - 100MHz target frequency
create_clock -name ip1_clk -period 10.0 [get_ports clk]

# Input delays relative to clock edge
set_input_delay -clock ip1_clk -max 2.0 [get_ports {data_in[7:0]}]
set_input_delay -clock ip1_clk -min 0.5 [get_ports {data_in[*]}]
set_input_delay -clock ip1_clk -max 1.5 [get_ports wr_en]
set_input_delay -clock ip1_clk -min 0.3 [get_ports wr_en]
set_input_delay -clock ip1_clk -max 1.5 [get_ports rd_en] 
set_input_delay -clock ip1_clk -min 0.3 [get_ports rd_en]

# Output delays for data and status
set_output_delay -clock ip1_clk -max 3.0 [get_ports {data_out[*]}]
set_output_delay -clock ip1_clk -min 0.8 [get_ports {data_out[*]}]
set_output_delay -clock ip1_clk -max 2.0 [get_ports full]
set_output_delay -clock ip1_clk -min 0.5 [get_ports full]
set_output_delay -clock ip1_clk -max 2.0 [get_ports empty]
set_output_delay -clock ip1_clk -min 0.5 [get_ports empty]

# Max transition time for outputs to prevent signal integrity issues
set_max_transition 0.5 [get_ports {data_out[*]}]
set_max_transition 0.3 [get_ports full]
set_max_transition 0.3 [get_ports empty]
