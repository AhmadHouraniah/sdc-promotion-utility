# SDC constraints for IP1 (FIFO Controller)
# Create clock constraint - 100MHz target frequency
create_clock -name ip1_clk -period 10.0 [get_ports fifo_clk]
# Input delays relative to clock edge
set_input_delay -clock ip1_clk -min 0.5 [get_ports {fifo_data_in[*]}]
set_input_delay -clock ip1_clk -min 0.3 [get_ports fifo_wr_en]
set_input_delay -clock ip1_clk -min 0.3 [get_ports fifo_rd_en]
# Output delays for data and status
set_output_delay -clock ip1_clk -min 0.8 [get_ports {fifo_data_out[*]}]
set_output_delay -clock ip1_clk -min 0.5 [get_ports fifo_full]
set_output_delay -clock ip1_clk -min 0.5 [get_ports fifo_empty]
# Reset is asynchronous, so false path from reset deassertion
set_false_path -from [get_ports fifo_rst_n] -to [all_registers]
# Max transition time for outputs to prevent signal integrity issues
set_max_transition 0.5 [get_ports {fifo_data_out[*]}]
set_max_transition 0.3 [get_ports fifo_full]
set_max_transition 0.3 [get_ports fifo_empty]
# SDC constraints for IP2 (Pipelined ALU)
create_clock -name ip2_clk -period 10.0 [get_ports alu_clk]
# Input delays for operands and control
set_input_delay -clock ip2_clk -min 0.6 [get_ports {alu_a[*]}]
set_input_delay -clock ip2_clk -min 0.6 [get_ports {alu_b[*]}]
set_input_delay -clock ip2_clk -min 0.4 [get_ports {alu_operation[*]}]
set_input_delay -clock ip2_clk -min 0.3 [get_ports alu_start]
# Output delays for results
set_output_delay -clock ip2_clk -min 1.0 [get_ports {alu_result[*]}]
set_output_delay -clock ip2_clk -min 0.6 [get_ports alu_done]
set_output_delay -clock ip2_clk -min 0.5 [get_ports alu_overflow]
# Reset is asynchronous
set_false_path -from [get_ports alu_rst_n] -to [all_registers]
# Max transition constraints for critical outputs
set_max_transition 0.6 [get_ports {alu_result[*]}]
set_max_transition 0.4 [get_ports alu_done]
set_max_transition 0.4 [get_ports alu_overflow]
# Multicycle path for the ALU computation (2 clock cycles for pipeline)
set_multicycle_path -setup 2 -from [get_ports {alu_a[*] alu_b[*] alu_operation[*]}] -to [get_ports {alu_result[*]}]
set_multicycle_path -hold 1 -from [get_ports {alu_a[*] alu_b[*] alu_operation[*]}] -to [get_ports {alu_result[*]}]
