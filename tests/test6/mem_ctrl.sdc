# Complex SDC constraints for Memory Controller
# DDR interface with multiple clock domains and strict timing

# Primary clock domains
create_clock -name system_domain -period 8.0 [get_ports sys_clk]
create_clock -name ddr_domain -period 4.0 [get_ports ddr_clk]
create_clock -name refresh_domain -period 64000.0 [get_ports ref_clk]

# Generated clocks from PLL outputs
create_generated_clock -name ddr_internal_clk -source [get_ports ddr_clk] -divide_by 1 [get_pins pll_lock_sync_reg[1]/Q]

# Clock groups - DDR domain synchronous to system, refresh independent
set_clock_groups -asynchronous -group {refresh_domain} -group {system_domain ddr_domain}
set_clock_groups -physically_exclusive -group {system_domain} -group {ddr_domain}

# Input constraints - VERY strict for command interface
set_input_delay -clock system_domain -max 1.0 [get_ports cmd_valid]
set_input_delay -clock system_domain -min 0.1 [get_ports cmd_valid]
set_input_delay -clock system_domain -max 1.2 [get_ports cmd_ready]
set_input_delay -clock system_domain -min 0.2 [get_ports cmd_ready]

# Command address - critical timing for 32-bit addressing
set_input_delay -clock system_domain -max 0.8 [get_ports cmd_addr[0]]
set_input_delay -clock system_domain -min 0.1 [get_ports cmd_addr[0]]
set_input_delay -clock system_domain -max 0.8 [get_ports cmd_addr[1]]
set_input_delay -clock system_domain -min 0.1 [get_ports cmd_addr[1]]
set_input_delay -clock system_domain -max 0.8 [get_ports cmd_addr[2]]
set_input_delay -clock system_domain -min 0.1 [get_ports cmd_addr[2]]
set_input_delay -clock system_domain -max 0.8 [get_ports cmd_addr[3]]
set_input_delay -clock system_domain -min 0.1 [get_ports cmd_addr[3]]
set_input_delay -clock system_domain -max 0.8 [get_ports cmd_addr[4]]
set_input_delay -clock system_domain -min 0.1 [get_ports cmd_addr[4]]
set_input_delay -clock system_domain -max 0.8 [get_ports cmd_addr[5]]
set_input_delay -clock system_domain -min 0.1 [get_ports cmd_addr[5]]

set_input_delay -clock system_domain -max 1.0 [get_ports cmd_write]
set_input_delay -clock system_domain -min 0.15 [get_ports cmd_write]
set_input_delay -clock system_domain -max 1.0 [get_ports cmd_burst_len[0]]
set_input_delay -clock system_domain -min 0.15 [get_ports cmd_burst_len[0]]
set_input_delay -clock system_domain -max 1.0 [get_ports cmd_burst_len[1]]
set_input_delay -clock system_domain -min 0.15 [get_ports cmd_burst_len[1]]
set_input_delay -clock system_domain -max 1.0 [get_ports cmd_burst_len[2]]
set_input_delay -clock system_domain -min 0.15 [get_ports cmd_burst_len[2]]
set_input_delay -clock system_domain -max 1.0 [get_ports cmd_burst_len[3]]
set_input_delay -clock system_domain -min 0.15 [get_ports cmd_burst_len[3]]

# Write data interface - EXTREMELY strict for data integrity
set_input_delay -clock system_domain -max 0.6 [get_ports wr_data[0]]
set_input_delay -clock system_domain -min 0.05 [get_ports wr_data[0]]
set_input_delay -clock system_domain -max 0.6 [get_ports wr_data[1]]
set_input_delay -clock system_domain -min 0.05 [get_ports wr_data[1]]
set_input_delay -clock system_domain -max 0.6 [get_ports wr_data[2]]
set_input_delay -clock system_domain -min 0.05 [get_ports wr_data[2]]
set_input_delay -clock system_domain -max 0.6 [get_ports wr_data[3]]
set_input_delay -clock system_domain -min 0.05 [get_ports wr_data[3]]
set_input_delay -clock system_domain -max 0.6 [get_ports wr_data[4]]
set_input_delay -clock system_domain -min 0.05 [get_ports wr_data[4]]
set_input_delay -clock system_domain -max 0.6 [get_ports wr_data[5]]
set_input_delay -clock system_domain -min 0.05 [get_ports wr_data[5]]
set_input_delay -clock system_domain -max 0.6 [get_ports wr_data[6]]
set_input_delay -clock system_domain -min 0.05 [get_ports wr_data[6]]
set_input_delay -clock system_domain -max 0.6 [get_ports wr_data[7]]
set_input_delay -clock system_domain -min 0.05 [get_ports wr_data[7]]

set_input_delay -clock system_domain -max 0.7 [get_ports wr_valid]
set_input_delay -clock system_domain -min 0.1 [get_ports wr_valid]
set_input_delay -clock system_domain -max 0.8 [get_ports rd_ready]
set_input_delay -clock system_domain -min 0.12 [get_ports rd_ready]

# DDR physical interface inputs - strict DDR4 timing
set_input_delay -clock ddr_domain -max 1.8 [get_ports ddr_dqs[0]]
set_input_delay -clock ddr_domain -min 0.2 [get_ports ddr_dqs[0]]
set_input_delay -clock ddr_domain -max 1.8 [get_ports ddr_dqs[1]]
set_input_delay -clock ddr_domain -min 0.2 [get_ports ddr_dqs[1]]
set_input_delay -clock ddr_domain -max 1.8 [get_ports ddr_dqs[2]]
set_input_delay -clock ddr_domain -min 0.2 [get_ports ddr_dqs[2]]
set_input_delay -clock ddr_domain -max 1.8 [get_ports ddr_dqs[3]]
set_input_delay -clock ddr_domain -min 0.2 [get_ports ddr_dqs[3]]

# DDR data input constraints
set_input_delay -clock ddr_domain -max 1.5 [get_ports ddr_dq[0]]
set_input_delay -clock ddr_domain -min 0.1 [get_ports ddr_dq[0]]
set_input_delay -clock ddr_domain -max 1.5 [get_ports ddr_dq[1]]
set_input_delay -clock ddr_domain -min 0.1 [get_ports ddr_dq[1]]
set_input_delay -clock ddr_domain -max 1.5 [get_ports ddr_dq[2]]
set_input_delay -clock ddr_domain -min 0.1 [get_ports ddr_dq[2]]
set_input_delay -clock ddr_domain -max 1.5 [get_ports ddr_dq[3]]
set_input_delay -clock ddr_domain -min 0.1 [get_ports ddr_dq[3]]

# Enable and control
set_input_delay -clock system_domain -max 1.5 [get_ports enable]
set_input_delay -clock system_domain -min 0.3 [get_ports enable]
set_input_delay -clock system_domain -max 1.2 [get_ports init_done]
set_input_delay -clock system_domain -min 0.25 [get_ports init_done]

# Output constraints - System domain outputs
set_output_delay -clock system_domain -max 2.0 [get_ports cmd_ready_out]
set_output_delay -clock system_domain -min 0.5 [get_ports cmd_ready_out]

# Read data outputs - strict timing for data integrity
set_output_delay -clock system_domain -max 2.5 [get_ports rd_data[0]]
set_output_delay -clock system_domain -min 0.8 [get_ports rd_data[0]]
set_output_delay -clock system_domain -max 2.5 [get_ports rd_data[1]]
set_output_delay -clock system_domain -min 0.8 [get_ports rd_data[1]]
set_output_delay -clock system_domain -max 2.5 [get_ports rd_data[2]]
set_output_delay -clock system_domain -min 0.8 [get_ports rd_data[2]]
set_output_delay -clock system_domain -max 2.5 [get_ports rd_data[3]]
set_output_delay -clock system_domain -min 0.8 [get_ports rd_data[3]]

set_output_delay -clock system_domain -max 2.2 [get_ports rd_valid]
set_output_delay -clock system_domain -min 0.7 [get_ports rd_valid]
set_output_delay -clock system_domain -max 2.0 [get_ports wr_ready]
set_output_delay -clock system_domain -min 0.6 [get_ports wr_ready]

# DDR physical outputs - CRITICAL DDR4 timing
set_output_delay -clock ddr_domain -max 0.8 [get_ports ddr_clk_p]
set_output_delay -clock ddr_domain -min 0.1 [get_ports ddr_clk_p]
set_output_delay -clock ddr_domain -max 0.8 [get_ports ddr_clk_n]
set_output_delay -clock ddr_domain -min 0.1 [get_ports ddr_clk_n]

# DDR command/address outputs
set_output_delay -clock ddr_domain -max 1.0 [get_ports ddr_cas_n]
set_output_delay -clock ddr_domain -min 0.15 [get_ports ddr_cas_n]
set_output_delay -clock ddr_domain -max 1.0 [get_ports ddr_ras_n]
set_output_delay -clock ddr_domain -min 0.15 [get_ports ddr_ras_n]
set_output_delay -clock ddr_domain -max 1.0 [get_ports ddr_we_n]
set_output_delay -clock ddr_domain -min 0.15 [get_ports ddr_we_n]

# DDR address outputs
set_output_delay -clock ddr_domain -max 1.2 [get_ports ddr_addr[0]]
set_output_delay -clock ddr_domain -min 0.2 [get_ports ddr_addr[0]]
set_output_delay -clock ddr_domain -max 1.2 [get_ports ddr_addr[1]]
set_output_delay -clock ddr_domain -min 0.2 [get_ports ddr_addr[1]]
set_output_delay -clock ddr_domain -max 1.2 [get_ports ddr_addr[2]]
set_output_delay -clock ddr_domain -min 0.2 [get_ports ddr_addr[2]]
set_output_delay -clock ddr_domain -max 1.2 [get_ports ddr_addr[3]]
set_output_delay -clock ddr_domain -min 0.2 [get_ports ddr_addr[3]]

set_output_delay -clock ddr_domain -max 1.1 [get_ports ddr_ba[0]]
set_output_delay -clock ddr_domain -min 0.18 [get_ports ddr_ba[0]]
set_output_delay -clock ddr_domain -max 1.1 [get_ports ddr_ba[1]]
set_output_delay -clock ddr_domain -min 0.18 [get_ports ddr_ba[1]]
set_output_delay -clock ddr_domain -max 1.1 [get_ports ddr_ba[2]]
set_output_delay -clock ddr_domain -min 0.18 [get_ports ddr_ba[2]]

set_output_delay -clock ddr_domain -max 1.0 [get_ports ddr_cs_n]
set_output_delay -clock ddr_domain -min 0.15 [get_ports ddr_cs_n]
set_output_delay -clock ddr_domain -max 1.0 [get_ports ddr_cke]
set_output_delay -clock ddr_domain -min 0.15 [get_ports ddr_cke]
set_output_delay -clock ddr_domain -max 1.0 [get_ports ddr_odt]
set_output_delay -clock ddr_domain -min 0.15 [get_ports ddr_odt]

# Status and error outputs
set_output_delay -clock system_domain -max 3.0 [get_ports init_complete]
set_output_delay -clock system_domain -min 1.0 [get_ports init_complete]
set_output_delay -clock system_domain -max 2.8 [get_ports error_status[0]]
set_output_delay -clock system_domain -min 0.9 [get_ports error_status[0]]
set_output_delay -clock system_domain -max 2.8 [get_ports error_status[1]]
set_output_delay -clock system_domain -min 0.9 [get_ports error_status[1]]
set_output_delay -clock system_domain -max 2.8 [get_ports error_status[2]]
set_output_delay -clock system_domain -min 0.9 [get_ports error_status[2]]

# False paths - asynchronous signals
set_false_path -from [get_ports init_done] -to [get_pins *init_state*/*]

# Multicycle paths - DDR initialization takes multiple cycles
set_multicycle_path -setup 4 -from [get_pins *init_state*/*] -to [get_pins *ddr_cmd*/*]
set_multicycle_path -hold 3 -from [get_pins *init_state*/*] -to [get_pins *ddr_cmd*/*]

# Refresh controller multicycle (slow refresh domain)
set_multicycle_path -setup 8000 -from [get_ports ref_clk] -to [get_pins *refresh_req*/*]
set_multicycle_path -hold 7999 -from [get_ports ref_clk] -to [get_pins *refresh_req*/*]

# Max delay constraints for critical DDR paths
set_max_delay 2.0 -from [get_pins *cmd_valid_sync2*/*] -to [get_pins *ddr_state*/*]
set_max_delay 1.5 -from [get_pins *ddr_state*/*] -to [get_ports ddr_cas_n]
set_max_delay 1.5 -from [get_pins *ddr_state*/*] -to [get_ports ddr_ras_n]
set_max_delay 1.5 -from [get_pins *ddr_state*/*] -to [get_ports ddr_we_n]

# Min delay for DDR command/address setup
set_min_delay 0.3 -from [get_pins *ddr_addr_reg*/*] -to [get_ports ddr_addr]
set_min_delay 0.25 -from [get_pins *ddr_ba_reg*/*] -to [get_ports ddr_ba]

# Max transition for DDR signal integrity (very strict)
set_max_transition 0.1 [get_ports ddr_clk_p]
set_max_transition 0.1 [get_ports ddr_clk_n]
set_max_transition 0.15 [get_ports ddr_cas_n]
set_max_transition 0.15 [get_ports ddr_ras_n]
set_max_transition 0.15 [get_ports ddr_we_n]
set_max_transition 0.2 [get_ports ddr_addr]
set_max_transition 0.18 [get_ports ddr_ba]

# DDR data strobe timing
set_max_transition 0.12 [get_ports ddr_dqs]
set_min_delay 0.05 -from [get_pins *ddr_dqs_reg*/*] -to [get_ports ddr_dqs]