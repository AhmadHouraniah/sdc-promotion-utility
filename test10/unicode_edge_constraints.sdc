# Unicode and extreme character edge case constraints
# Testing very long constraint lines and special characters

# Clock constraints with extreme names
create_clock -name clk_main_100mhz_primary -period 10.0 [get_ports clk_main_domain_100mhz_primary_oscillator]
create_clock -name clk_aux_50mhz_secondary -period 20.0 [get_ports clk_auxiliary_domain_50mhz_secondary_pll_output]

# Generated clocks with complex names
create_generated_clock -name \\derived_clock$from/main_domain  -source [get_ports clk_main_domain_100mhz_primary_oscillator] -divide_by 4 [get_pins \\internal_wire$with/special_chars ]

# Input delay constraints with ultra-wide buses
set_input_delay -clock clk_main_100mhz_primary -max 8.5 [get_ports {\\ultra_wide_bus_signal_with_1024_bits_for_testing_maximum_length_handling_in_parser [1023:0]}]
set_input_delay -clock clk_main_100mhz_primary -min 1.2 [get_ports {\\ultra_wide_bus_signal_with_1024_bits_for_testing_maximum_length_handling_in_parser [1023:0]}]

# Output delay constraints with negative ranges
set_output_delay -clock clk_main_100mhz_primary -max 7.8 [get_ports {\\negative_output_range [31:-8]}]
set_output_delay -clock clk_main_100mhz_primary -min 0.8 [get_ports {\\negative_output_range [31:-8]}]

# False path constraints with wildcards and special characters
set_false_path -from [get_ports \\signal_with_$_dollar_sign ] -to [get_ports \\complex_output$signal/path ]
set_false_path -from [get_ports {\\path/to/hierarchical$signal_name }] -to [get_registers {\\internal_mega_wide_register_2048_bits [*]}]

# Multicycle path with extremely long signal names
set_multicycle_path -setup 3 -from [get_registers {\\very_long_signal_name_that_exceeds_normal_limits_and_continues_for_testing_maximum_length_handling_in_parser }] -to [get_registers {\\output_ultra_wide_bus_1024_bits [*]}]
set_multicycle_path -hold 2 -from [get_registers {\\very_long_signal_name_that_exceeds_normal_limits_and_continues_for_testing_maximum_length_handling_in_parser }] -to [get_registers {\\output_ultra_wide_bus_1024_bits [*]}]

# Maximum transition constraints with corner case ranges
set_max_transition 2.5 [get_ports {\\single_bit_range_signal [7]}]
set_max_transition 5.0 [get_ports {\\reversed_range_signal [0:127]}]

# Load constraints with bidirectional signals
set_load 0.8 [get_ports {\\bidirectional_bus_with_long_name_for_testing_parser_limits [*]}]
set_load 1.2 [get_ports \\bidir$special/char_signal ]

# Drive strength constraints
set_drive 4.0 [get_ports CamelCaseSignalName]
set_drive 6.0 [get_ports snake_case_signal_name]
set_drive 8.0 [get_ports \\mixed$Case/Signal_Name ]

# Clock groups with special character clocks
set_clock_groups -asynchronous -group {clk_main_100mhz_primary} -group {clk_aux_50mhz_secondary \\derived_clock$from/main_domain }

# Set case analysis for testing edge cases
set_case_analysis 1 [get_ports \\signal_123_456_789 ]
set_case_analysis 0 [get_ports \\signal_with_0x_prefix ]

# Disable timing with complex wildcards
set_disable_timing [get_cells {\\gen_block$complex/name [*].\\generated_signal_array }] -from * -to *

# Maximum fanout constraints
set_max_fanout 16 [get_ports reset_system_wide_asynchronous_active_low_synchronized]

# Environment constraints for extreme cases
set_operating_conditions -max slow_corner -max_library slow_lib
set_operating_conditions -min fast_corner -min_library fast_lib