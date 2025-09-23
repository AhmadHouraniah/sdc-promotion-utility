# Edge case SDC with complex patterns and various constraint types

# Multiple clock definitions with different patterns
create_clock -name main_clk -period 8.0 [get_ports clk]
create_clock -name alt_clk -period 12.5 [get_ports alt_clk]

# Generated clocks
create_generated_clock -name internal_clk -source [get_ports clk] -divide_by 2 [get_pins internal_clk_gen/Q]

# Complex I/O delay constraints with different patterns
set_input_delay 2.0 -clock main_clk [get_ports data_in_bus_0*]
set_input_delay 1.5 -clock main_clk -max [get_ports ctrl_sig_a2b[*]]
set_input_delay 1.0 -clock main_clk -min [get_ports ctrl_sig_a2b[*]]

# Output delays with wildcards and specific bits
set_output_delay 3.0 -clock main_clk [get_ports result_out_vec*]
set_output_delay 2.5 -clock main_clk [get_ports status_flag_x]

# Cross-domain constraints
set_input_delay 4.0 -clock alt_clk [get_ports async_data*]

# False path constraints with complex patterns
set_false_path -from [get_ports rst_n] -to [get_registers *internal_reg*]
set_false_path -from [get_clocks alt_clk] -to [get_clocks main_clk]

# Multicycle path constraints
set_multicycle_path 2 -setup -from [get_registers *internal_reg*] -to [get_ports result_out_vec*]
set_multicycle_path 1 -hold -from [get_registers *internal_reg*] -to [get_ports result_out_vec*]

# Transition and delay constraints
set_max_transition 0.8 [get_ports result_out_vec*]
set_max_delay 5.0 -from [get_ports data_in_bus_0*] -to [get_ports result_out_vec*]
set_min_delay 0.5 -from [get_ports data_in_bus_0*] -to [get_ports result_out_vec*]

# Clock group constraints
set_clock_groups -asynchronous -group [get_clocks main_clk] -group [get_clocks alt_clk]

# Edge case: Constraints that should be ignored (internal registers)
set_max_delay 2.0 -from [get_registers *internal_reg*] -to [get_registers *status_reg*]

# Edge case: Bidirectional port constraints (should be handled carefully)
set_input_delay 1.8 -clock main_clk [get_ports bidir_port*]
set_output_delay 2.2 -clock main_clk [get_ports bidir_port*]