# Malformed SDC constraints - intentionally broken syntax

# Missing clock name
create_clock -period 10.0 [get_ports clk]

# Invalid period value
create_clock -name bad_clk -period abc [get_ports clk_broken]

# Unclosed brackets
create_clock -name clk_test -period 5.0 [get_ports clk_signal

# Invalid constraint syntax
set_input_delay -clock clk_test -max [get_ports data_signal]

# Missing required parameters
set_output_delay [get_ports output_signal]

# Invalid object references
set_false_path -from [get_ports nonexistent_signal] -to [get_ports another_nonexistent]

# Malformed wildcards
set_multicycle_path -setup 2 -from [get_cells {*[}] -to [get_cells {*]}

# Invalid timing values
set_max_transition -1.5 [get_ports signal]
set_min_delay abc [get_ports signal]

# Unclosed comments
/* This comment is never closed

# Syntax errors in clock groups
set_clock_groups -asynchronous -group {clk1 clk2 -group {clk3}

# Invalid escape sequences
set_false_path -from [get_ports \invalid_escape_sequence] -to [get_ports signal]

# Missing semicolons and malformed lines
set_load 0.5 [get_ports signal
set_drive 2.0 get_ports signal]

# Empty constraint
set_input_delay