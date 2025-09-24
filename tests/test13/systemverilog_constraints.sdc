# SystemVerilog advanced constructs constraints (UPDATED)
# Testing parameter-based constraints and complex structures - Updated for converted Verilog RTL

# Clock constraints for multiple domains
create_clock -name clk_a -period 8.0 [get_ports clk_domain_a]
create_clock -name clk_b -period 12.0 [get_ports clk_domain_b]

# Input delay constraints for packed arrays (updated signal names)
set_input_delay -clock clk_a -max 6.5 [get_ports {packed_array_input[255:0]}]
set_input_delay -clock clk_a -min 1.0 [get_ports {packed_array_input[255:0]}]

# Multi-dimensional array constraints (updated signal names)
set_input_delay -clock clk_b -max 9.0 [get_ports {multi_dim_input[63:0]}]
set_input_delay -clock clk_b -min 1.5 [get_ports {multi_dim_input[63:0]}]

# Output delay constraints for packed arrays (updated signal names)
set_output_delay -clock clk_a -max 5.5 [get_ports {packed_array_output[255:0]}]
set_output_delay -clock clk_a -min 0.8 [get_ports {packed_array_output[255:0]}]

set_output_delay -clock clk_b -max 7.0 [get_ports {multi_dim_output[63:0]}]
set_output_delay -clock clk_b -min 1.2 [get_ports {multi_dim_output[63:0]}]

# Struct-like signal constraints (updated signal names)
set_input_delay -clock clk_a -max 5.0 [get_ports {struct_like_signal[63:0]}]
set_input_delay -clock clk_a -min 0.5 [get_ports {struct_like_signal[63:0]}]
set_output_delay -clock clk_a -max 4.5 [get_ports {struct_like_output[63:0]}]
set_output_delay -clock clk_a -min 0.7 [get_ports {struct_like_output[63:0]}]

# Enumerated type constraints (updated signal names)
set_input_delay -clock clk_a -max 3.0 [get_ports {enum_state_signal[2:0]}]
set_input_delay -clock clk_a -min 0.3 [get_ports {enum_state_signal[2:0]}]
set_output_delay -clock clk_a -max 2.8 [get_ports {enum_next_state[2:0]}]
set_output_delay -clock clk_a -min 0.4 [get_ports {enum_next_state[2:0]}]

# AXI interface constraints (updated signal names)
set_input_delay -clock clk_a -max 4.0 [get_ports axi_awvalid]
set_input_delay -clock clk_a -max 4.0 [get_ports {axi_awaddr[15:0]}]
set_input_delay -clock clk_a -max 4.0 [get_ports {axi_wdata[31:0]}]
set_input_delay -clock clk_a -max 4.0 [get_ports {axi_wstrb[3:0]}]

set_output_delay -clock clk_a -max 3.5 [get_ports axi_awready]
set_output_delay -clock clk_a -max 3.5 [get_ports axi_wready]

# Master-slave interface constraints (updated signal names)
set_input_delay -clock clk_a -max 4.5 [get_ports master_req]
set_input_delay -clock clk_a -max 4.5 [get_ports {master_data[31:0]}]
set_output_delay -clock clk_a -max 4.0 [get_ports master_ack]

set_input_delay -clock clk_a -max 4.5 [get_ports slave_req]
set_output_delay -clock clk_a -max 4.0 [get_ports {slave_data[31:0]}]
set_output_delay -clock clk_a -max 4.0 [get_ports slave_ack]

# Advanced SystemVerilog feature constraints (updated signal names)
set_input_delay -clock clk_b -max 8.0 [get_ports {queue_like_signal_size[15:0]}]
set_input_delay -clock clk_b -max 8.0 [get_ports {dynamic_array_element[31:0]}]
set_output_delay -clock clk_b -max 7.5 [get_ports {associative_array_key[7:0]}]

# False paths between clock domains
set_false_path -from [get_clocks clk_a] -to [get_clocks clk_b]
set_false_path -from [get_clocks clk_b] -to [get_clocks clk_a]

# Multicycle paths for complex operations
set_multicycle_path -setup 2 -from [get_ports {struct_like_signal[63:0]}] -to [get_ports {struct_like_output[63:0]}]
set_multicycle_path -hold 1 -from [get_ports {struct_like_signal[63:0]}] -to [get_ports {struct_like_output[63:0]}]

# Maximum transition constraints for high-speed signals
set_max_transition 1.5 [get_ports {packed_array_input[255:0]}]
set_max_transition 1.5 [get_ports {packed_array_output[255:0]}]

# Load constraints for interface signals
set_load 0.6 [get_ports axi_awready]
set_load 0.6 [get_ports axi_wready]
set_load 0.8 [get_ports master_ack]
set_load 0.8 [get_ports slave_ack]

# Drive constraints for input signals
set_drive 3.0 [get_ports master_req]
set_drive 3.0 [get_ports slave_req]
set_drive 2.5 [get_ports axi_awvalid]

# Clock uncertainty for advanced timing analysis
set_clock_uncertainty -setup 0.2 [get_clocks clk_a]
set_clock_uncertainty -hold 0.1 [get_clocks clk_a]
set_clock_uncertainty -setup 0.3 [get_clocks clk_b]
set_clock_uncertainty -hold 0.15 [get_clocks clk_b]

# Clock groups for proper domain isolation
set_clock_groups -asynchronous -group {clk_a} -group {clk_b}