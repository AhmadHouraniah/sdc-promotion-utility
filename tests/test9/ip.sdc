# ===================================================================
# DESIGN COMPILER GENERATED SDC - EXTREME PATHOLOGICAL TEST CASES (UPDATED)
# This file simulates the most extreme cases found in real DC output:
# - Updated signal names to match fixed RTL
# - Extremely long constraint lines
# - Mixed formatting nightmares
# - Complex wildcards and bus notations
# - Embedded comments in strange places
# - Massive indentation inconsistencies
# ===== BASIC CLOCKS WITH DC ESCAPE SEQUENCES =====
create_clock -name {main_clk_200mhz} -period 5.000 [get_ports main_clk_200mhz]
create_clock -name {periph_clk_100mhz} -period 10.000 [get_ports periph_clk_100mhz]
create_clock -name {memory_clk_400mhz} -period 2.500 [get_ports memory_clk_400mhz]
create_clock -name {debug_clk_external} -period 20.000 [get_ports debug_clk_external]
# Generated clocks based on updated signal names
create_generated_clock -name {u_processor_core_inst1/clk_periph_50mhz} -source [get_ports periph_clk_100mhz] -divide_by 2 [get_pins {u_processor_core_inst1/clk_periph_50mhz}]
create_generated_clock -name {u_processor_core_inst1/clk_periph_25mhz} -source [get_pins {u_processor_core_inst1/clk_periph_50mhz}] -divide_by 2 [get_pins {u_processor_core_inst1/clk_periph_25mhz}]
# ===== CLOCK GROUPS WITH UPDATED NAMES =====
set_clock_groups -asynchronous \
-group {main_clk_200mhz} \
-group {periph_clk_100mhz u_processor_core_inst1/clk_periph_50mhz u_processor_core_inst1/clk_periph_25mhz} \
-group {memory_clk_400mhz} \
-group {debug_clk_external}
# ===== PATHOLOGICAL INPUT DELAYS WITH EXTREME FORMATTING =====
# This simulates the worst possible DC formatting
# Extremely long lines with multiple signals (DC loves these)
# Mixed formatting with random spaces and tabs (absolute nightmare)
set_input_delay -clock main_clk_200mhz -max 2.500 [get_ports {ext_axi_proc1_wdata[127:0] ext_axi_proc1_wstrb[15:0] ext_axi_proc1_wvalid}]
set_input_delay -clock main_clk_200mhz -min 0.100 [get_ports {ext_axi_proc1_wdata[127:0] ext_axi_proc1_wstrb[15:0] ext_axi_proc1_wvalid}]

set_input_delay -clock main_clk_200mhz -max 2.100 [get_ports {ext_axi_proc1_araddr[63:0] ext_axi_proc1_arlen[7:0] ext_axi_proc1_arsize[2:0] ext_axi_proc1_arburst[1:0] ext_axi_proc1_arvalid}]
set_input_delay -clock main_clk_200mhz -min 0.200 [get_ports {ext_axi_proc1_araddr[63:0] ext_axi_proc1_arlen[7:0] ext_axi_proc1_arsize[2:0] ext_axi_proc1_arburst[1:0] ext_axi_proc1_arvalid}]

# Processor 2 AXI interface constraints
set_input_delay -clock main_clk_200mhz -max 2.500 [get_ports {ext_axi_proc2_wdata[127:0] ext_axi_proc2_wstrb[15:0] ext_axi_proc2_wvalid}]
set_input_delay -clock main_clk_200mhz -min 0.100 [get_ports {ext_axi_proc2_wdata[127:0] ext_axi_proc2_wstrb[15:0] ext_axi_proc2_wvalid}]

# ===== OUTPUT DELAYS WITH PATHOLOGICAL NAMES =====
# Wide bus outputs with complex names
set_output_delay -clock main_clk_200mhz -max 1.800 [get_ports {ext_axi_proc1_rdata[127:0] ext_axi_proc1_rresp[1:0] ext_axi_proc1_rlast ext_axi_proc1_rvalid}]
set_output_delay -clock main_clk_200mhz -min 0.050 [get_ports {ext_axi_proc1_rdata[127:0] ext_axi_proc1_rresp[1:0] ext_axi_proc1_rlast ext_axi_proc1_rvalid}]

# Peripheral outputs with mixed clock domains
set_output_delay -clock periph_clk_100mhz -max 4.500 [get_ports {ext_periph_gpio_out_bank_a[31:0] ext_periph_gpio_enable_bank_a[31:0]}]
set_output_delay -clock periph_clk_100mhz -min 0.300 [get_ports {ext_periph_gpio_out_bank_a[31:0] ext_periph_gpio_enable_bank_a[31:0]}]
# ===== LOAD CONSTRAINTS WITH COMPLEX SIGNAL PATTERNS =====
set_load 0.500 [get_ports {ext_axi_proc1_wready ext_axi_proc1_arready}]
set_load 0.300 [get_ports {ext_axi_proc1_rdata[127:0]}]
set_load 0.150 [get_ports {ext_axi_proc1_rresp[1:0] ext_axi_proc1_rlast ext_axi_proc1_rvalid}]
# GPIO loads with mixed naming
set_load 0.800 [get_ports {ext_periph_gpio_out_bank_a[31:0] ext_periph_gpio_enable_bank_a[31:0]}]
set_load 0.600 [get_ports {ext_periph_gpio_out_bank_b[31:0] ext_periph_gpio_enable_bank_b[31:0]}]
# ===== TRANSITION CONSTRAINTS WITH EXTREME WILDCARDS =====
set_max_transition 0.500 [get_ports {main_clk_200mhz periph_clk_100mhz memory_clk_400mhz debug_clk_external}]
set_max_transition 0.500 [get_ports {main_clk_200mhz periph_clk_100mhz memory_clk_400mhz debug_clk_external}]
set_max_transition 0.500 [get_ports {main_clk_200mhz periph_clk_100mhz memory_clk_400mhz debug_clk_external}]
set_max_transition 0.500 [get_ports {main_clk_200mhz periph_clk_100mhz memory_clk_400mhz debug_clk_external}]
set_max_transition 0.300 [get_ports {system_reset_n_external debug_reset_n_external power_on_reset_n}]
set_max_transition 0.300 [get_ports {system_reset_n_external debug_reset_n_external power_on_reset_n}]
set_max_transition 0.300 [get_ports {system_reset_n_external debug_reset_n_external power_on_reset_n}]
# Complex wildcard patterns (updated for new signal names)
set_max_transition 0.800 [get_ports {ext_axi_proc*_*data[*]}]
set_max_transition 0.600 [get_ports {ext_axi_proc*_*addr[*]}]
set_max_transition 0.400 [get_ports {ext_axi_proc*_*valid}]
set_max_transition 0.400 [get_ports {ext_axi_proc*_*valid}]
set_max_transition 0.400 [get_ports {ext_axi_proc*_*valid}]
set_max_transition 0.400 [get_ports {ext_axi_proc*_*valid}]
# Mixed transition constraints with pathological formatting
set_max_transition	0.700	[get_ports	{	ext_periph_apb_*	}]
set_max_transition	0.700	[get_ports	{	ext_periph_apb_*	}]
set_max_transition	0.700	[get_ports	{	ext_periph_apb_*	}]
set_max_transition  0.350  [get_ports  {  ext_periph_gpio_*_*  }]
set_max_transition  0.350  [get_ports  {  ext_periph_gpio_*_*  }]
# ===== DRIVING CELL CONSTRAINTS WITH COMPLEX LIBRARIES =====
set_driving_cell -lib_cell {BUFX16_HVT} -pin {Y} [get_ports {main_clk_200mhz periph_clk_100mhz}]
set_driving_cell -lib_cell {BUFX8_LVT} -pin {Y} [get_ports {memory_clk_400mhz debug_clk_external}]
set_driving_cell -lib_cell {INVX4_HVT} -pin {Y} [get_ports {system_reset_n_external debug_reset_n_external power_on_reset_n}]
# Complex driving cells for data signals
set_driving_cell -lib_cell {BUFX2_LVT} -pin {Y} [get_ports {ext_axi_proc1_wdata[127:0] ext_axi_proc1_wstrb[15:0]}]
set_driving_cell -lib_cell {BUFX1_LVT} -pin {Y} [get_ports {ext_axi_proc1_araddr[63:0] ext_axi_proc1_arlen[7:0] ext_axi_proc1_arsize[2:0] ext_axi_proc1_arburst[1:0]}]
# ===== FALSE PATH CONSTRAINTS WITH EXTREMELY COMPLEX PATTERNS =====
# Reset domain crossings
set_false_path -from [get_ports {system_reset_n_external debug_reset_n_external power_on_reset_n}] \
-to [all_registers]
# Clock domain crossings with complex pin patterns (updated signal names)
set_false_path \
    -from [get_pins {u_processor_core_inst1/power_mgmt_clock_gate_enable }] \
    -to [get_pins {u_peripheral_controller_inst1/apb_*}]

set_false_path \
    -from [get_pins {u_processor_core_inst2/power_mgmt_clock_gate_enable  }] \
    -to [get_pins {u_peripheral_controller_inst1/gpio_*}]

# Extremely long false path with multiple signal names and wildcards (updated)
set_false_path \
    -from [get_pins {u_processor_core_inst1/debug_jtag_* u_processor_core_inst1/test_* u_processor_core_inst2/debug_jtag_* u_processor_core_inst2/test_*}] \
    -to [get_pins {u_peripheral_controller_inst1/gpio_* u_peripheral_controller_inst1/spi_* u_peripheral_controller_inst1/uart* u_peripheral_controller_inst1/timer_* u_peripheral_controller_inst1/pwm_* u_peripheral_controller_inst1/dma_*}]
# ===== MAX DELAY CONSTRAINTS WITH PATHOLOGICAL HIERARCHICAL PATHS =====
# Performance critical paths with clean signal names (updated)
set_max_delay 5.000 \
    -from [get_pins {u_processor_core_inst1/ext_ddr4_*}] \
    -to [get_pins {u_processor_core_inst1/ddr4_ctrl_cmd_valid_o}]

set_max_delay 4.500 \
    -from [get_pins {u_processor_core_inst2/ext_ddr4_*}] \
    -to [get_pins {u_processor_core_inst2/ddr4_ctrl_cmd_valid_o}]

# Cross-instance communication paths
set_max_delay 6.000 -from [get_pins {u_processor_core_inst1/irq_ack_out[*]}] \
                    -to [get_pins {u_processor_core_inst2/irq_vector_in[*]}]

# Complex max delay with through points and wildcards
set_max_delay 8.000 \
-from [get_pins {u_processor_core_inst*/ext_ddr4_*}] \
-to [get_ports {ext_ddr4_*}]
# ===== MIN DELAY CONSTRAINTS WITH COMPLEX PATTERNS =====
set_min_delay 0.500 \
    -from [get_ports {ext_axi_proc1_wdata[127:0] ext_axi_proc1_wstrb[15:0]}] \
    -to [get_pins {u_processor_core_inst1/ext_axi_proc1_*}]

set_min_delay 0.300 \
    -from [get_ports {ext_axi_proc1_araddr[63:0] ext_axi_proc1_arlen[7:0]}] \
    -to [get_pins {u_processor_core_inst2/ext_axi_proc1_*}]
# ===== MULTICYCLE PATH CONSTRAINTS WITH EXTREME COMPLEXITY =====
# Setup multicycle for complex data paths
set_multicycle_path -setup 3 \
-from [get_pins {u_processor_core_inst1/ddr4_ctrl_cmd_valid_o}] \
-to [get_pins {u_processor_core_inst1/ddr4_ctrl_rdata_valid_i}]
set_multicycle_path -hold 2 \
-from [get_pins {u_processor_core_inst1/ddr4_ctrl_cmd_valid_o}] \
-to [get_pins {u_processor_core_inst1/ddr4_ctrl_rdata_valid_i}]

# Cross-domain multicycle with complex wildcards
set_multicycle_path -setup 4 \
-from [get_pins {u_processor_core_inst*/perf_mon_*}] \
-to [get_pins {u_peripheral_controller_inst1/performance_*}]
# ===== DISABLE TIMING WITH PATHOLOGICAL TEST SIGNALS =====
# Disable timing for scan and test signals
set_disable_timing [get_ports {ext_scan_* ext_test_* ext_jtag_*}] -from
set_disable_timing [get_ports {ext_scan_* ext_test_* ext_jtag_*}] -to

# ===== IDEAL NETWORKS FOR CLOCKS AND CRITICAL SIGNALS =====
set_ideal_network [get_ports {main_clk_200mhz periph_clk_100mhz memory_clk_400mhz debug_clk_external}]
set_ideal_network [get_ports {system_reset_n_external debug_reset_n_external power_on_reset_n}]
# Ideal networks for generated clocks
set_ideal_network [get_pins {u_processor_core_inst1/clk_periph_50mhz u_processor_core_inst1/clk_periph_25mhz}]
# ===== PATHOLOGICAL TIMING EXCEPTIONS =====
# Multi-cycle paths with complex patterns
set_multicycle_path -setup 2 -from [get_pins {u_processor_core_inst*/perf_mon_*}] -to [get_pins {u_peripheral_controller_inst1/performance_*}]
set_multicycle_path -hold 1 -from [get_pins {u_processor_core_inst*/perf_mon_*}] -to [get_pins {u_peripheral_controller_inst1/performance_*}]

# Min/Max delays for critical paths
set_min_delay 0.100 -from [get_ports system_reset_n_external] -to [all_registers]
set_max_delay 8.000 -from [get_pins {u_processor_core_inst*/ext_ddr4_*}] -to [get_ports {ext_ddr4_*}]

# ===== PATHOLOGICAL LOAD CONSTRAINTS =====
# Typical DC output with extreme repetition and bad formatting
set_max_capacitance 0.050 [get_ports ext_axi_proc1_wdata[0]]
set_max_capacitance 0.050 [get_ports ext_axi_proc1_wdata[1]]
set_max_capacitance 0.050 [get_ports ext_axi_proc1_wdata[2]]
set_max_capacitance 0.050 [get_ports ext_axi_proc1_wdata[3]]
set_max_capacitance 0.050 [get_ports ext_axi_proc1_wdata[4]]
# ... (would continue for all bits in real DC output)

# Load constraints for output ports
set_load 0.025 [get_ports {ext_axi_proc1_rdata[127:0] ext_axi_proc1_rresp[1:0]}]
set_load 0.030 [get_ports {ext_periph_gpio_out_bank_a[31:0]}]

# ===== CASE ANALYSIS FOR TEST MODES =====
set_case_analysis 0 [get_ports ext_scan_enable]
set_case_analysis 0 [get_ports ext_test_mode]

# ===== PATHOLOGICAL GROUPING =====
# Path groups with long names (typical DC behavior)
group_path -name {main_clk_200mhz_setup_critical_paths_group} -from [get_clocks main_clk_200mhz]
group_path -name {periph_clk_100mhz_hold_critical_paths_group} -from [get_clocks periph_clk_100mhz]
group_path -name {memory_clk_400mhz_max_delay_paths_group} -from [get_clocks memory_clk_400mhz]

# ===== ENVIRONMENT CONSTRAINTS =====
set_operating_conditions -max {WCCOM} -max_library {tcbn40lpbwpwc} -min {BCCOM} -min_library {tcbn40lpbwpbc}
set_wire_load_model -name {TSMC40_WLM} -library {tcbn40lpbwpwc}

# ===== FINAL PATHOLOGICAL CONSTRAINTS =====
# These simulate the absolute worst DC formatting nightmares
set_max_fanout   50   [current_design]
set_max_area     0
