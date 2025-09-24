# Fixed malformed SDC constraints - corrected syntax to match fixed RTL

# Fixed: Added clock name and valid port reference
create_clock -name clk_broken -period 10.0 [get_ports clk_broken]

# Fixed: Valid period value and correct port reference  
create_clock -name clk_test -period 5.0 [get_ports clk_broken]

# Fixed: Proper input delay constraint
set_input_delay -clock clk_broken -max 2.5 [get_ports {data_bus_missing_direction[7:0]}]

# Fixed: Complete output delay constraint
set_output_delay -clock clk_broken -max 3.0 [get_ports broken_output]

# Fixed: Valid signal references that match the RTL
set_false_path -from [get_ports rst_n] -to [get_ports broken_output]

# Fixed: Proper multicycle path constraint with valid references
set_multicycle_path -setup 2 -from [get_ports signal1] -to [get_ports signal2]

# Fixed: Valid timing values
set_max_transition 1.5 [get_ports valid_signal]
set_min_delay 0.5 [get_ports valid_signal]

# Fixed: Proper constraints for corrected signal names
set_input_delay -clock clk_broken -max 2.0 [get_ports {unclosed_bracket_signal[15:0]}]
set_input_delay -clock clk_broken -max 2.0 [get_ports {invalid_range_signal[15:8]}]

# Load constraints for fixed signals
set_load 0.5 [get_ports signal_with_escaped_dollars]
set_load 0.5 [get_ports signal_with_escaped_slashes]

# Drive constraints for corrected range signals
set_drive 2.0 [get_ports {negative_start_range[8:0]}]
set_drive 2.0 [get_ports {non_numeric_range[5:0]}]

# Clock groups
set_clock_groups -asynchronous -group {clk_broken clk_test}

# Case analysis
set_case_analysis 0 [get_ports rst_n]

# Environment constraints
set_operating_conditions -max WORST -min BEST

# Syntax errors in clock groups
set_clock_groups -asynchronous -group {clk1 clk2 -group {clk3}

# Invalid escape sequences
set_false_path -from [get_ports \invalid_escape_sequence] -to [get_ports signal]

# Missing semicolons and malformed lines
set_load 0.5 [get_ports signal
set_drive 2.0 get_ports signal]

# Empty constraint
set_input_delay