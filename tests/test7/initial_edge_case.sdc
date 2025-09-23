# Initial top-level SDC with existing constraints
# This tests the initial SDC integration feature

# Top-level clocks with different names (potential conflicts)
create_clock -name sys_clk -period 10.0 [get_ports sys_clk]
create_clock -name sec_clk -period 15.0 [get_ports secondary_clk]

# Existing I/O constraints (should take precedence)
set_input_delay 2.5 -clock sys_clk [get_ports external_data_bus*]
set_output_delay 3.5 -clock sys_clk [get_ports chip_output_data*]

# Top-level specific constraints
set_input_delay 1.0 -clock sys_clk [get_ports test_mode]
set_output_delay 2.0 -clock sys_clk [get_ports debug_output*]

# Clock uncertainty
set_clock_uncertainty 0.1 [get_clocks sys_clk]
set_clock_uncertainty 0.15 [get_clocks sec_clk]

# Load constraints
set_load 0.5 [get_ports chip_output_data*]
set_load 0.3 [get_ports debug_output*]