# Complex SDC test cases for debugging
# Test 1: Basic port constraints
set_input_delay -clock clk 2.0 [get_ports din]
set_output_delay -clock clk 1.5 [get_ports dout]

# Test 2: Braced signals
set_driving_cell -cell BUFX2 [get_ports {reset_n}]
set_load 0.1 [get_ports {enable}]

# Test 3: Indexed signals
set_input_delay -clock clk 2.0 [get_ports {data_bus[0]}]
set_input_delay -clock clk 2.0 [get_ports {data_bus[1]}]
set_port_fanout_number 4 [get_ports {addr[7]}]

# Test 4: Hierarchical paths
set_max_delay 5.0 -from [get_pins sub_module/reg_out] -to [get_pins output_reg/D]
set_false_path -from [get_pins control_unit/reset_sync] -to [get_pins *]

# Test 5: Clock constraints
create_clock -period 10.0 [get_ports clk]
set_clock_uncertainty 0.2 [get_clocks clk]

# Test 6: Mixed hierarchical and port references
set_multicycle_path 2 -from [get_pins fifo/write_ptr*] -to [get_ports status_out]

# Test 7: Complex timing exceptions
set_false_path -through [get_pins mux_ctrl/sel] -from [get_ports test_mode]

# Test 8: Generated clocks
create_generated_clock -source [get_ports ref_clk] -divide_by 2 [get_pins pll/clk_out]

# Test 9: Multiple signals in one constraint
set_input_transition 0.1 [get_ports {clk reset_n enable}]

# Test 10: Wildcard patterns
set_max_transition 0.5 [get_ports data_*]
set_false_path -to [get_pins */scan_*]