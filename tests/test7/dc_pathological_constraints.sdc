# ===================================================================
# DESIGN COMPILER GENERATED SDC - EXTREME PATHOLOGICAL TEST CASES
# ===================================================================
# This file simulates the most extreme cases found in real DC output:
# - Escaped signal names with special characters
# - Extremely long constraint lines  
# - Mixed formatting nightmares
# - Complex wildcards and bus notations
# - Embedded comments in strange places
# - Massive indentation inconsistencies
# ===================================================================

# ===== BASIC CLOCKS WITH DC ESCAPE SEQUENCES =====
create_clock -name {main_clk_200mhz} -period 5.000 [get_ports main_clk_200mhz]
create_clock -name {periph_clk_100mhz} -period 10.000 [get_ports periph_clk_100mhz]  
create_clock -name {memory_clk_400mhz} -period 2.500 [get_ports memory_clk_400mhz]
create_clock -name {debug_clk_external} -period 20.000 [get_ports debug_clk_external]

# Escaped clock names with special characters (typical in DC netlists)
create_generated_clock -name {\clk_periph_50mhz/generated } -source [get_ports periph_clk_100mhz] -divide_by 2 [get_pins {u_peripheral_controller_inst1/\clk_periph_50mhz/generated }]
create_generated_clock -name {\clk_periph_25mhz/generated } -source [get_pins {u_peripheral_controller_inst1/\clk_periph_50mhz/generated }] -divide_by 2 [get_pins {u_peripheral_controller_inst1/\clk_periph_25mhz/generated }]

# ===== CLOCK GROUPS WITH ESCAPED NAMES =====
set_clock_groups -asynchronous \
    -group {main_clk_200mhz} \
    -group {periph_clk_100mhz \clk_periph_50mhz/generated  \clk_periph_25mhz/generated } \
    -group {memory_clk_400mhz} \
    -group {debug_clk_external}

# ===== PATHOLOGICAL INPUT DELAYS WITH EXTREME FORMATTING =====
# This simulates the worst possible DC formatting
set_input_delay -clock main_clk_200mhz -max 2.500 [get_ports {\axi4_slave_if/s_axi_wdata[127:0] }]
set_input_delay -clock main_clk_200mhz -min 0.500 [get_ports {\axi4_slave_if/s_axi_wdata[127:0] }]  
set_input_delay -clock main_clk_200mhz -max 2.800 [get_ports {\axi4_slave_if/s_axi_wstrb[15:0] }]
set_input_delay -clock main_clk_200mhz -min 0.300 [get_ports {\axi4_slave_if/s_axi_wstrb[15:0] }]
set_input_delay -clock main_clk_200mhz -max 2.200 [get_ports {\axi4_slave_if/s_axi_wvalid_qualified }]
set_input_delay -clock main_clk_200mhz -min 0.800 [get_ports {\axi4_slave_if/s_axi_wvalid_qualified }]

# Extremely long lines with multiple escaped signals (DC loves these)
set_input_delay -clock main_clk_200mhz -max 3.200 [get_ports {\axi4_slave_if/s_axi_araddr[63:0]  \axi4_slave_if/s_axi_arlen[7:0]  \axi4_slave_if/s_axi_arsize[2:0]  \axi4_slave_if/s_axi_arburst[1:0]  \axi4_slave_if/s_axi_arvalid_sync }]
set_input_delay -clock main_clk_200mhz -min 0.600 [get_ports {\axi4_slave_if/s_axi_araddr[63:0]  \axi4_slave_if/s_axi_arlen[7:0]  \axi4_slave_if/s_axi_arsize[2:0]  \axi4_slave_if/s_axi_arburst[1:0]  \axi4_slave_if/s_axi_arvalid_sync }]

# Mixed formatting with random spaces and tabs (absolute nightmare)
set_input_delay		-clock	periph_clk_100mhz	-max	2.800	[get_ports	{	\apb_if_v2_1/paddr[31:0] 	\apb_if_v2_1/psel_qualified 	\apb_if_v2_1/penable_sync 	\apb_if_v2_1/pwrite_direction 	\apb_if_v2_1/pwdata[31:0] 	}]
set_input_delay    -clock   periph_clk_100mhz   -min   0.400   [get_ports   {   \apb_if_v2_1/paddr[31:0]    \apb_if_v2_1/psel_qualified    \apb_if_v2_1/penable_sync    \apb_if_v2_1/pwrite_direction    \apb_if_v2_1/pwdata[31:0]    }]

# ===== OUTPUT DELAYS WITH PATHOLOGICAL NAMES =====
set_output_delay -clock main_clk_200mhz -max 3.500 [get_ports {\axi4_slave_if/s_axi_wready_internal }]
set_output_delay -clock main_clk_200mhz -min 1.200 [get_ports {\axi4_slave_if/s_axi_wready_internal }]
set_output_delay -clock main_clk_200mhz -max 4.000 [get_ports {\axi4_slave_if/s_axi_arready_comb }]
set_output_delay -clock main_clk_200mhz -min 1.500 [get_ports {\axi4_slave_if/s_axi_arready_comb }]

# Wide bus outputs with complex names
set_output_delay -clock main_clk_200mhz -max 3.800 [get_ports {\axi4_slave_if/s_axi_rdata[127:0]  \axi4_slave_if/s_axi_rresp[1:0]  \axi4_slave_if/s_axi_rlast_generated  \axi4_slave_if/s_axi_rvalid_final }]
set_output_delay -clock main_clk_200mhz -min 1.000 [get_ports {\axi4_slave_if/s_axi_rdata[127:0]  \axi4_slave_if/s_axi_rresp[1:0]  \axi4_slave_if/s_axi_rlast_generated  \axi4_slave_if/s_axi_rvalid_final }]

# Peripheral outputs with mixed clock domains
set_output_delay -clock periph_clk_100mhz -max 4.200 [get_ports {\apb_if_v2_1/prdata[31:0]  \apb_if_v2_1/pready_response  \apb_if_v2_1/pslverr_indicator }]
set_output_delay -clock periph_clk_100mhz -min 1.800 [get_ports {\apb_if_v2_1/prdata[31:0]  \apb_if_v2_1/pready_response  \apb_if_v2_1/pslverr_indicator }]

# ===== LOAD CONSTRAINTS WITH COMPLEX SIGNAL PATTERNS =====
set_load 0.500 [get_ports {\axi4_slave_if/s_axi_wready_internal  \axi4_slave_if/s_axi_arready_comb }]
set_load 0.300 [get_ports {\axi4_slave_if/s_axi_rdata[127:0] }]
set_load 0.150 [get_ports {\axi4_slave_if/s_axi_rresp[1:0]  \axi4_slave_if/s_axi_rlast_generated  \axi4_slave_if/s_axi_rvalid_final }]

# GPIO loads with mixed naming
set_load 0.800 [get_ports {ext_periph_gpio_a_out ext_periph_gpio_a_oe}] 
set_load 0.600 [get_ports {ext_periph_gpio_b_out ext_periph_gpio_b_oe}]

# ===== TRANSITION CONSTRAINTS WITH EXTREME WILDCARDS =====
set_max_transition 0.500 [get_ports {main_clk_200mhz periph_clk_100mhz memory_clk_400mhz debug_clk_external}]
set_max_transition 0.300 [get_ports {system_reset_n_external debug_reset_n_external power_on_reset_n}]

# Complex wildcard patterns (DC generates these)
set_max_transition 0.800 [get_ports {\axi4_slave_if/s_axi_*data[*] }]
set_max_transition 0.600 [get_ports {\axi4_slave_if/s_axi_*addr[*] }]
set_max_transition 0.400 [get_ports {\axi4_slave_if/s_axi_*valid* }]

# Mixed transition constraints with pathological formatting
set_max_transition	0.700	[get_ports	{	\apb_if_v2_1/p*[*]	}]
set_max_transition  0.350  [get_ports  {  ext_periph_gpio_*_*  }]

# ===== DRIVING CELL CONSTRAINTS WITH COMPLEX LIBRARIES =====
set_driving_cell -lib_cell {BUFX16_HVT} -pin {Y} [get_ports {main_clk_200mhz periph_clk_100mhz}]
set_driving_cell -lib_cell {BUFX8_LVT} -pin {Y} [get_ports {memory_clk_400mhz debug_clk_external}]
set_driving_cell -lib_cell {INVX4_HVT} -pin {Y} [get_ports {system_reset_n_external debug_reset_n_external power_on_reset_n}]

# Complex driving cells for data signals
set_driving_cell -lib_cell {BUFX2_LVT} -pin {Y} [get_ports {\axi4_slave_if/s_axi_wdata[127:0]  \axi4_slave_if/s_axi_wstrb[15:0] }]
set_driving_cell -lib_cell {BUFX1_LVT} -pin {Y} [get_ports {\axi4_slave_if/s_axi_araddr[63:0]  \axi4_slave_if/s_axi_arlen[7:0]  \axi4_slave_if/s_axi_arsize[2:0]  \axi4_slave_if/s_axi_arburst[1:0] }]

# ===== FALSE PATH CONSTRAINTS WITH EXTREMELY COMPLEX PATTERNS =====
# Reset domain crossings
set_false_path -from [get_ports {system_reset_n_external debug_reset_n_external power_on_reset_n}] \
               -to [all_registers]

# Clock domain crossings with complex pin patterns  
set_false_path -from [get_pins {u_processor_core_inst1/\clk_ctrl_v3_2/clk_domain_crossing_req_* }] \
               -to [get_pins {u_peripheral_controller_inst1/\periph_test_ctrl/scan_*_periph_* }]

set_false_path -from [get_pins {u_processor_core_inst2/\clk_ctrl_v3_2/clk_domain_crossing_req_* }] \
               -to [get_pins {u_peripheral_controller_inst1/\periph_irq_controller/irq_*_* }]

# Extremely long false path with multiple escaped names and wildcards
set_false_path -from [get_pins {u_processor_core_inst1/\debug_if_v2_3/jtag_*$*  u_processor_core_inst1/\test_ctrl_v1_5/scan_*_*$*  u_processor_core_inst2/\debug_if_v2_3/jtag_*$*  u_processor_core_inst2/\test_ctrl_v1_5/scan_*_*$* }] \
               -to [get_pins {u_peripheral_controller_inst1/\periph_test_ctrl/scan_*_periph_*  u_peripheral_controller_inst1/\periph_irq_controller/irq_*_*  u_peripheral_controller_inst1/\gpio_bank_*/output_*  u_peripheral_controller_inst1/\spi_master_v3_1_inst*/cs_n[*]  u_peripheral_controller_inst1/\uart*_*/r*_*  u_peripheral_controller_inst1/\timer_subsys_v2_4/timer*_*  u_peripheral_controller_inst1/\pwm_controller_v1_3/pwm_*  u_peripheral_controller_inst1/\dma_engine_v3_2_1/master_axi_*[*] }]

# ===== MAX DELAY CONSTRAINTS WITH PATHOLOGICAL HIERARCHICAL PATHS =====
# Performance critical paths with complex escaped names
set_max_delay 5.000 -from [get_pins {u_processor_core_inst1/\axi4_slave_if/s_axi_arvalid_sync }] \
                    -to [get_pins {u_processor_core_inst1/\mem_subsys/ddr4_ctrl_v1_2/cmd_valid_o }]

set_max_delay 4.500 -from [get_pins {u_processor_core_inst2/\axi4_slave_if/s_axi_arvalid_sync }] \
                    -to [get_pins {u_processor_core_inst2/\mem_subsys/ddr4_ctrl_v1_2/cmd_valid_o }]

# Cross-instance communication paths
set_max_delay 6.000 -from [get_pins {u_processor_core_inst1/\irq_controller_v3_1/irq_ack_out[*] }] \
                    -to [get_pins {u_processor_core_inst2/\irq_controller_v3_1/irq_vector_in[*] }]

# Extremely complex max delay with through points and wildcards
set_max_delay 8.000 \
    -from [get_pins {u_processor_core_inst*/\axi4_slave_if/s_axi_*valid* }] \
    -through [get_pins {u_processor_core_inst*/\mem_subsys/ddr4_ctrl_v1_2/*_out[*] }] \
    -to [get_ports {ext_ddr4_* }]

# ===== MIN DELAY CONSTRAINTS WITH COMPLEX PATTERNS =====
set_min_delay 0.500 -from [get_ports {\axi4_slave_if/s_axi_wdata[127:0]  \axi4_slave_if/s_axi_wstrb[15:0] }] \
                    -to [get_pins {u_processor_core_inst1/\axi4_slave_if/s_axi_w*_* }]

set_min_delay 0.300 -from [get_ports {\axi4_slave_if/s_axi_araddr[63:0]  \axi4_slave_if/s_axi_arlen[7:0] }] \
                    -to [get_pins {u_processor_core_inst2/\axi4_slave_if/s_axi_ar*_* }]

# ===== MULTICYCLE PATH CONSTRAINTS WITH EXTREME COMPLEXITY =====
# Setup multicycle for complex data paths
set_multicycle_path -setup 3 \
    -from [get_pins {u_processor_core_inst1/\mem_subsys/ddr4_ctrl_v1_2/cmd_valid_o }] \
    -to [get_pins {u_processor_core_inst1/\mem_subsys/ddr4_ctrl_v1_2/rdata_valid_i }]

set_multicycle_path -hold 2 \
    -from [get_pins {u_processor_core_inst1/\mem_subsys/ddr4_ctrl_v1_2/cmd_valid_o }] \
    -to [get_pins {u_processor_core_inst1/\mem_subsys/ddr4_ctrl_v1_2/rdata_valid_i }]

# Cross-domain multicycle with complex wildcards
set_multicycle_path -setup 4 \
    -from [get_pins {u_processor_core_inst*/\perf_monitor_subsys_v4_2_1/*_count_*[*] }] \
    -to [get_pins {u_peripheral_controller_inst1/\periph_irq_controller/irq_out_*[*] }]

# ===== DISABLE TIMING WITH PATHOLOGICAL TEST SIGNALS =====
# Disable timing for scan and test signals
set_disable_timing -from [get_pins {u_processor_core_inst1/\test_ctrl_v1_5/scan_enable_mode$functional }] \
                   -to [get_pins {u_processor_core_inst1/\test_ctrl_v1_5/scan_out_primary_chain }]

set_disable_timing -from [get_pins {u_processor_core_inst2/\test_ctrl_v1_5/scan_enable_mode$functional }] \
                   -to [get_pins {u_processor_core_inst2/\test_ctrl_v1_5/scan_out_primary_chain }]

set_disable_timing -from [get_pins {u_peripheral_controller_inst1/\periph_test_ctrl/scan_enable_periph_domain }] \
                   -to [get_pins {u_peripheral_controller_inst1/\periph_test_ctrl/scan_out_periph_chain }]

# Complex disable timing with wildcards and escaped names
set_disable_timing -from [get_pins {u_processor_core_inst*/\debug_if_v2_3/jtag_*$* }] \
                   -to [get_pins {u_processor_core_inst*/\debug_if_v2_3/jtag_tdo_registered }]

# ===== IDEAL NETWORKS FOR CLOCKS AND CRITICAL SIGNALS =====
set_ideal_network [get_ports {main_clk_200mhz periph_clk_100mhz memory_clk_400mhz debug_clk_external}]
set_ideal_network [get_ports {system_reset_n_external debug_reset_n_external power_on_reset_n}]

# Ideal networks for generated clocks
set_ideal_network [get_pins {u_peripheral_controller_inst1/\clk_periph_50mhz/generated  u_peripheral_controller_inst1/\clk_periph_25mhz/generated }]

# ===== EXTREMELY PATHOLOGICAL FORMATTING TEST =====
# This section tests the most extreme formatting cases possible

# Massive indentation with mixed tabs and spaces
		set_max_delay		10.000		\
			-from		[get_pins		{		u_processor_core_inst1/\perf_monitor_subsys_v4_2_1/cycle_count_main_core[63:0] 		u_processor_core_inst1/\perf_monitor_subsys_v4_2_1/instruction_count_pipeline[63:0] 		u_processor_core_inst1/\perf_monitor_subsys_v4_2_1/cache_miss_count_l1_data[31:0] 		u_processor_core_inst1/\perf_monitor_subsys_v4_2_1/cache_miss_count_l1_instruction[31:0] 		u_processor_core_inst1/\perf_monitor_subsys_v4_2_1/pipeline_stall_count_total[31:0] 		}]		\
			-to		[get_pins		{		u_processor_core_inst2/\perf_monitor_subsys_v4_2_1/cycle_count_main_core[63:0] 		u_processor_core_inst2/\perf_monitor_subsys_v4_2_1/instruction_count_pipeline[63:0] 		u_processor_core_inst2/\perf_monitor_subsys_v4_2_1/cache_miss_count_l1_data[31:0] 		u_processor_core_inst2/\perf_monitor_subsys_v4_2_1/cache_miss_count_l1_instruction[31:0] 		u_processor_core_inst2/\perf_monitor_subsys_v4_2_1/pipeline_stall_count_total[31:0] 		}]

# Line breaks in weird places
set_false_path \
-from \
[get_pins \
{ \
u_processor_core_inst1/\pwr_mgmt_v2_1/power_good_vdd_core \
u_processor_core_inst1/\pwr_mgmt_v2_1/power_good_vdd_io \
u_processor_core_inst1/\pwr_mgmt_v2_1/power_good_vdd_memory \
u_processor_core_inst2/\pwr_mgmt_v2_1/power_good_vdd_core \
u_processor_core_inst2/\pwr_mgmt_v2_1/power_good_vdd_io \
u_processor_core_inst2/\pwr_mgmt_v2_1/power_good_vdd_memory \
}] \
-to \
[get_pins \
{ \
u_peripheral_controller_inst1/\dma_engine_v3_2_1/master_axi_awaddr[31:0] \
u_peripheral_controller_inst1/\dma_engine_v3_2_1/master_axi_awlen[7:0] \
u_peripheral_controller_inst1/\dma_engine_v3_2_1/master_axi_awsize[2:0] \
u_peripheral_controller_inst1/\dma_engine_v3_2_1/master_axi_awvalid_req \
u_peripheral_controller_inst1/\dma_engine_v3_2_1/master_axi_wdata[63:0] \
u_peripheral_controller_inst1/\dma_engine_v3_2_1/master_axi_wstrb[7:0] \
u_peripheral_controller_inst1/\dma_engine_v3_2_1/master_axi_wlast_indicator \
u_peripheral_controller_inst1/\dma_engine_v3_2_1/master_axi_wvalid_strobe \
}]

# ===== FINAL STRESS TEST - EVERYTHING COMBINED =====
# This is the ultimate test combining all pathological patterns
set_multicycle_path -setup 5 -hold 3 \
    -from [get_ports {\axi4_slave_if/s_axi_*[*] }] \
    -through [get_pins {u_processor_core_inst*/\mem_subsys/ddr4_ctrl_v1_2/*[*] }] \
    -through [get_pins {u_processor_core_inst*/\axi4_slave_if/*$* }] \
    -to [get_pins {u_peripheral_controller_inst1/\dma_engine_v3_2_1/master_axi_*[*] }] \
    -comment "Ultimate pathological multicycle constraint test"

# End of pathological SDC test file