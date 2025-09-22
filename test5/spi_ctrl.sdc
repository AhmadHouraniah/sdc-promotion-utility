# Complex SDC constraints for SPI Controller
# Multiple clock domains with strict timing requirements

# Primary clock domains
create_clock -name core_domain -period 10.0 [get_ports core_clk]
create_clock -name serial_tx_domain -period 40.0 [get_ports sclk_out]  
create_clock -name serial_rx_domain -period 40.0 [get_ports sclk_in]

# Generated clocks for internal dividers
create_generated_clock -name spi_internal_clk -source [get_ports core_clk] -divide_by 4 [get_pins clk_div_counter_reg[1]/Q]

# Clock groups (asynchronous domains)
set_clock_groups -asynchronous -group {core_domain} -group {serial_tx_domain serial_rx_domain}

# Input constraints - STRICT timing for control signals
set_input_delay -clock core_domain -max 1.5 [get_ports enable]
set_input_delay -clock core_domain -min 0.2 [get_ports enable]
set_input_delay -clock core_domain -max 1.2 [get_ports mode_sel]
set_input_delay -clock core_domain -min 0.3 [get_ports mode_sel]

# Very strict timing for configuration
set_input_delay -clock core_domain -max 0.8 [get_ports cpol_cpha[0]]
set_input_delay -clock core_domain -min 0.1 [get_ports cpol_cpha[0]]
set_input_delay -clock core_domain -max 0.8 [get_ports cpol_cpha[1]]
set_input_delay -clock core_domain -min 0.1 [get_ports cpol_cpha[1]]

# Clock divider settings
set_input_delay -clock core_domain -max 2.0 [get_ports div_ratio[0]]
set_input_delay -clock core_domain -min 0.5 [get_ports div_ratio[0]]
set_input_delay -clock core_domain -max 2.0 [get_ports div_ratio[1]]
set_input_delay -clock core_domain -min 0.5 [get_ports div_ratio[1]]
set_input_delay -clock core_domain -max 2.0 [get_ports div_ratio[2]]
set_input_delay -clock core_domain -min 0.5 [get_ports div_ratio[2]]
set_input_delay -clock core_domain -max 2.0 [get_ports div_ratio[3]]
set_input_delay -clock core_domain -min 0.5 [get_ports div_ratio[3]]
set_input_delay -clock core_domain -max 2.0 [get_ports div_ratio[4]]
set_input_delay -clock core_domain -min 0.5 [get_ports div_ratio[4]]
set_input_delay -clock core_domain -max 2.0 [get_ports div_ratio[5]]
set_input_delay -clock core_domain -min 0.5 [get_ports div_ratio[5]]
set_input_delay -clock core_domain -max 2.0 [get_ports div_ratio[6]]
set_input_delay -clock core_domain -min 0.5 [get_ports div_ratio[6]]
set_input_delay -clock core_domain -max 2.0 [get_ports div_ratio[7]]
set_input_delay -clock core_domain -min 0.5 [get_ports div_ratio[7]]

# Data interface - VERY strict for 32-bit data
set_input_delay -clock core_domain -max 1.0 [get_ports tx_data[0]]
set_input_delay -clock core_domain -min 0.1 [get_ports tx_data[0]]
set_input_delay -clock core_domain -max 1.0 [get_ports tx_data[1]]
set_input_delay -clock core_domain -min 0.1 [get_ports tx_data[1]]
set_input_delay -clock core_domain -max 1.0 [get_ports tx_data[2]]
set_input_delay -clock core_domain -min 0.1 [get_ports tx_data[2]]
set_input_delay -clock core_domain -max 1.0 [get_ports tx_data[3]]
set_input_delay -clock core_domain -min 0.1 [get_ports tx_data[3]]
set_input_delay -clock core_domain -max 1.0 [get_ports tx_data[4]]
set_input_delay -clock core_domain -min 0.1 [get_ports tx_data[4]]
set_input_delay -clock core_domain -max 1.0 [get_ports tx_data[5]]
set_input_delay -clock core_domain -min 0.1 [get_ports tx_data[5]]

# Control signals
set_input_delay -clock core_domain -max 1.8 [get_ports tx_valid]
set_input_delay -clock core_domain -min 0.4 [get_ports tx_valid]
set_input_delay -clock core_domain -max 1.6 [get_ports rx_ready]
set_input_delay -clock core_domain -min 0.3 [get_ports rx_ready]

# SPI physical interface inputs
set_input_delay -clock serial_rx_domain -max 15.0 [get_ports spi_miso]
set_input_delay -clock serial_rx_domain -min 5.0 [get_ports spi_miso]

# Output constraints - STRICT timing requirements
set_output_delay -clock core_domain -max 2.0 [get_ports tx_ready]
set_output_delay -clock core_domain -min 0.5 [get_ports tx_ready]

# 32-bit output data constraints
set_output_delay -clock core_domain -max 2.5 [get_ports rx_data[0]]
set_output_delay -clock core_domain -min 0.8 [get_ports rx_data[0]]
set_output_delay -clock core_domain -max 2.5 [get_ports rx_data[1]]
set_output_delay -clock core_domain -min 0.8 [get_ports rx_data[1]]
set_output_delay -clock core_domain -max 2.5 [get_ports rx_data[2]]
set_output_delay -clock core_domain -min 0.8 [get_ports rx_data[2]]
set_output_delay -clock core_domain -max 2.5 [get_ports rx_data[3]]
set_output_delay -clock core_domain -min 0.8 [get_ports rx_data[3]]

set_output_delay -clock core_domain -max 1.8 [get_ports rx_valid]
set_output_delay -clock core_domain -min 0.6 [get_ports rx_valid]

# SPI physical outputs - VERY strict for signal integrity
set_output_delay -clock serial_tx_domain -max 8.0 [get_ports spi_cs_n]
set_output_delay -clock serial_tx_domain -min 2.0 [get_ports spi_cs_n]
set_output_delay -clock serial_tx_domain -max 12.0 [get_ports spi_mosi]
set_output_delay -clock serial_tx_domain -min 3.0 [get_ports spi_mosi]
set_output_delay -clock serial_tx_domain -max 10.0 [get_ports spi_sclk]
set_output_delay -clock serial_tx_domain -min 2.5 [get_ports spi_sclk]

# Status outputs
set_output_delay -clock core_domain -max 3.0 [get_ports busy]
set_output_delay -clock core_domain -min 1.0 [get_ports busy]
set_output_delay -clock core_domain -max 2.8 [get_ports error_flags[0]]
set_output_delay -clock core_domain -min 0.9 [get_ports error_flags[0]]
set_output_delay -clock core_domain -max 2.8 [get_ports error_flags[1]]
set_output_delay -clock core_domain -min 0.9 [get_ports error_flags[1]]
set_output_delay -clock core_domain -max 2.8 [get_ports error_flags[2]]
set_output_delay -clock core_domain -min 0.9 [get_ports error_flags[2]]
set_output_delay -clock core_domain -max 2.8 [get_ports error_flags[3]]
set_output_delay -clock core_domain -min 0.9 [get_ports error_flags[3]]

# False paths for asynchronous reset
set_false_path -from [get_ports arst_n] -to [all_registers]

# Multicycle paths for configuration setup (takes 2 cycles)
set_multicycle_path -setup 2 -from [get_ports div_ratio] -to [get_registers *clk_div_counter*]
set_multicycle_path -hold 1 -from [get_ports div_ratio] -to [get_registers *clk_div_counter*]

# Max delay constraints for critical paths
set_max_delay 5.0 -from [get_registers *enable_sync2*] -to [get_registers *state*]
set_max_delay 3.0 -from [get_registers *tx_valid_sync2*] -to [get_registers *spi_active*]

# Min delay for setup/hold
set_min_delay 0.5 -from [get_registers *state*] -to [get_ports tx_ready]

# Max transition constraints for signal integrity
set_max_transition 0.2 [get_ports spi_cs_n]
set_max_transition 0.3 [get_ports spi_mosi]
set_max_transition 0.25 [get_ports spi_sclk]
set_max_transition 0.4 [get_ports busy]