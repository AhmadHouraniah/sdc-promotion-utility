# Comprehensive IP constraints - multiple clock domains and advanced timing (REVIEWED)
# Testing complex clock relationships and cross-domain constraints - Updated for clean RTL

# Primary clocks
create_clock -name clk_main_200mhz -period 5.0 [get_ports clk_main_200mhz]
create_clock -name clk_mem_400mhz -period 2.5 [get_ports clk_mem_400mhz]
create_clock -name clk_pcie_125mhz -period 8.0 [get_ports clk_pcie_125mhz]
create_clock -name clk_usb_60mhz -period 16.667 [get_ports clk_usb_60mhz]

# GPIO interface timing (main clock domain)
set_input_delay -clock clk_main_200mhz -max 2.0 [get_ports {gpio_input_data[*]}]
set_input_delay -clock clk_main_200mhz -min 0.5 [get_ports {gpio_input_data[*]}]
set_output_delay -clock clk_main_200mhz -max 1.5 [get_ports {gpio_output_data[*]}]
set_output_delay -clock clk_main_200mhz -min 0.3 [get_ports {gpio_output_data[*]}]

# Memory interface timing (high-speed memory clock)
set_input_delay -clock clk_mem_400mhz -max 1.0 [get_ports {mem_read_data[*]}]
set_input_delay -clock clk_mem_400mhz -min 0.2 [get_ports {mem_read_data[*]}]
set_input_delay -clock clk_mem_400mhz -max 0.8 [get_ports mem_ready]
set_output_delay -clock clk_mem_400mhz -max 0.8 [get_ports {mem_addr_bus[*]}]
set_output_delay -clock clk_mem_400mhz -max 0.8 [get_ports {mem_write_data[*]}]
set_output_delay -clock clk_mem_400mhz -max 0.6 [get_ports mem_write_enable]
set_output_delay -clock clk_mem_400mhz -max 0.6 [get_ports mem_read_enable]

# High-speed serial interface (PCIe clock domain)
set_input_delay -clock clk_pcie_125mhz -max 3.0 [get_ports {serial_rx_data[*]}]
set_input_delay -clock clk_pcie_125mhz -min 0.8 [get_ports {serial_rx_data[*]}]
set_input_delay -clock clk_pcie_125mhz -max 2.5 [get_ports serial_rx_valid]
set_input_delay -clock clk_pcie_125mhz -max 2.5 [get_ports serial_rx_ready]
set_output_delay -clock clk_pcie_125mhz -max 2.0 [get_ports {serial_tx_data[*]}]
set_output_delay -clock clk_pcie_125mhz -max 1.8 [get_ports serial_tx_valid]
set_output_delay -clock clk_pcie_125mhz -max 1.8 [get_ports serial_tx_ready]

# Control and status interface timing
set_input_delay -clock clk_main_200mhz -max 3.0 [get_ports {control_register[*]}]
set_output_delay -clock clk_main_200mhz -max 2.5 [get_ports {status_register[*]}]
set_output_delay -clock clk_main_200mhz -max 2.0 [get_ports interrupt_signal]

# Performance counters
set_output_delay -clock clk_main_200mhz -max 3.0 [get_ports {performance_counter_0[*]}]
set_output_delay -clock clk_mem_400mhz -max 1.5 [get_ports {performance_counter_1[*]}]
set_output_delay -clock clk_pcie_125mhz -max 2.5 [get_ports {performance_counter_2[*]}]
set_output_delay -clock clk_usb_60mhz -max 8.0 [get_ports {performance_counter_3[*]}]

# Clock domain crossing constraints
set_clock_groups -asynchronous -group [get_clocks clk_main_200mhz] \
                                -group [get_clocks clk_mem_400mhz] \
                                -group [get_clocks clk_pcie_125mhz] \
                                -group [get_clocks clk_usb_60mhz]

# False paths for reset
set_false_path -from [get_ports reset_n] -to [all_registers]

# Maximum delay constraints for critical paths
set_max_delay 20.0 -from [get_registers {*gpio_output_reg*}] -to [get_ports {gpio_output_data[*]}]
set_max_delay 10.0 -from [get_registers {*mem_addr_reg*}] -to [get_ports {mem_addr_bus[*]}]
set_max_delay 15.0 -from [get_registers {*serial_tx_reg*}] -to [get_ports {serial_tx_data[*]}]

# Multicycle paths for performance counters (relaxed timing)
set_multicycle_path -setup 2 -from [get_registers {*perf_counter*}] -to [get_ports {performance_counter*}]
set_multicycle_path -hold 1 -from [get_registers {*perf_counter*}] -to [get_ports {performance_counter*}]