# Initial SDC constraints for test6 top-level
# These constraints should take precedence over promoted ones

# Top-level clock constraints with different periods (should override promoted ones)
create_clock -name core_domain -period 12.0 [get_ports core_clock_int]
create_clock -name system_domain -period 6.0 [get_ports memory_sys_clk]

# Top-level input delays that should override IP constraints
set_input_delay -clock core_domain -max 2.5 [get_ports spi_chip_enable]
set_input_delay -clock core_domain -min 0.3 [get_ports spi_chip_enable]

# Additional top-level constraints
set_input_delay -clock system_domain -max 1.8 [get_ports memory_command_valid]
set_input_delay -clock system_domain -min 0.4 [get_ports memory_command_valid]

# Global constraints that apply to all signals
set_max_fanout 16 [all_nets]
set_max_capacitance 0.5 [all_nets]

# Top-level false paths
set_false_path -from [get_ports chip_enable_n] -to [all_registers]

# Clock domain crossings at top level
set_false_path -from [get_clocks core_domain] -to [get_clocks system_domain]
set_false_path -from [get_clocks system_domain] -to [get_clocks core_domain]