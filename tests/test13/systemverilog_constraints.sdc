# SystemVerilog advanced constructs constraints
# Testing parameter-based constraints and complex structures

# Clock constraints for multiple domains
create_clock -name clk_a -period 8.0 [get_ports clk_domain_a]
create_clock -name clk_b -period 12.0 [get_ports clk_domain_b]

# Input delay constraints for packed arrays
set_input_delay -clock clk_a -max 6.5 [get_ports {packed_array_input[*]}]
set_input_delay -clock clk_a -min 1.0 [get_ports {packed_array_input[*]}]

# Multi-dimensional array constraints
set_input_delay -clock clk_b -max 9.0 [get_ports {multi_dim_input[*]}]
set_input_delay -clock clk_b -min 1.5 [get_ports {multi_dim_input[*]}]

# Output delay constraints for packed arrays
set_output_delay -clock clk_a -max 5.5 [get_ports {packed_array_output[*]}]
set_output_delay -clock clk_a -min 0.8 [get_ports {packed_array_output[*]}]

set_output_delay -clock clk_b -max 7.0 [get_ports {multi_dim_output[*]}]
set_output_delay -clock clk_b -min 1.2 [get_ports {multi_dim_output[*]}]

# Struct-like signal constraints
set_input_delay -clock clk_a -max 5.0 [get_ports {struct_like_signal[63:0]}]
set_input_delay -clock clk_a -min 0.5 [get_ports {struct_like_signal[63:0]}]
set_output_delay -clock clk_a -max 4.5 [get_ports {struct_like_output[63:0]}]
set_output_delay -clock clk_a -min 0.7 [get_ports {struct_like_output[63:0]}]

# Enumerated type constraints
set_input_delay -clock clk_a -max 3.0 [get_ports {enum_state_signal[2:0]}]
set_input_delay -clock clk_a -min 0.3 [get_ports {enum_state_signal[2:0]}]
set_output_delay -clock clk_a -max 2.8 [get_ports {enum_next_state[2:0]}]
set_output_delay -clock clk_a -min 0.4 [get_ports {enum_next_state[2:0]}]

# AXI interface constraints
set_input_delay -clock clk_a -max 4.0 [get_ports axi_awvalid]
set_input_delay -clock clk_a -max 4.0 [get_ports {axi_awaddr[*]}]
set_input_delay -clock clk_a -max 4.0 [get_ports {axi_wdata[*]}]
set_input_delay -clock clk_a -max 4.0 [get_ports {axi_wstrb[*]}]

set_output_delay -clock clk_a -max 3.5 [get_ports axi_awready]
set_output_delay -clock clk_a -max 3.5 [get_ports axi_wready]

# Master-slave interface constraints
set_input_delay -clock clk_a -max 4.5 [get_ports master_req]
set_input_delay -clock clk_a -max 4.5 [get_ports {master_data[*]}]
set_output_delay -clock clk_a -max 4.0 [get_ports master_ack]

set_input_delay -clock clk_a -max 4.5 [get_ports slave_req]
set_output_delay -clock clk_a -max 4.0 [get_ports {slave_data[*]}]
set_output_delay -clock clk_a -max 4.0 [get_ports slave_ack]

# Advanced SystemVerilog feature constraints
set_input_delay -clock clk_b -max 8.0 [get_ports {\\queue_like_signal$size [*]}]
set_input_delay -clock clk_b -max 8.0 [get_ports {\\dynamic_array$element [*]}]
set_output_delay -clock clk_b -max 7.5 [get_ports {\\associative_array$key [*]}]

# False paths between clock domains
set_false_path -from [get_clocks clk_a] -to [get_clocks clk_b]
set_false_path -from [get_clocks clk_b] -to [get_clocks clk_a]

# Multicycle paths for complex operations
set_multicycle_path -setup 2 -from [get_ports {struct_like_signal[*]}] -to [get_ports {struct_like_output[*]}]
set_multicycle_path -hold 1 -from [get_ports {struct_like_signal[*]}] -to [get_ports {struct_like_output[*]}]

# Maximum transition constraints for high-speed signals
set_max_transition 1.5 [get_ports {packed_array_input[*]}]
set_max_transition 1.5 [get_ports {packed_array_output[*]}]

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

# Set case analysis for feature enable
set_case_analysis 1 [get_pins {*/ENABLE_FEATURE}]

# Clock groups for proper domain isolation
set_clock_groups -asynchronous -group {clk_a} -group {clk_b}