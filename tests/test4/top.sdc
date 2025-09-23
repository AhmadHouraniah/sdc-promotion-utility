# SDC constraints for top-level module with FIFO and ALU
# Create main system clock constraint - 100MHz target frequency
create_clock -name sys_clk -period 10.0 [get_ports sys_clk]

# Input delays relative to system clock edge
set_input_delay -clock sys_clk -min 0.5 [get_ports {fifo_data_in[*]}]
set_input_delay -clock sys_clk -min 0.3 [get_ports fifo_wr_en]
set_input_delay -clock sys_clk -min 0.3 [get_ports fifo_rd_en]
set_input_delay -clock sys_clk -min 0.6 [get_ports {alu_a[*]}]
set_input_delay -clock sys_clk -min 0.6 [get_ports {alu_b[*]}]
set_input_delay -clock sys_clk -min 0.4 [get_ports {alu_operation[*]}]
set_input_delay -clock sys_clk -min 0.3 [get_ports alu_start]

# Output delays for all outputs
set_output_delay -clock sys_clk -min 0.8 [get_ports {fifo_data_out[*]}]
set_output_delay -clock sys_clk -min 0.5 [get_ports fifo_full]
set_output_delay -clock sys_clk -min 0.5 [get_ports fifo_empty]
set_output_delay -clock sys_clk -min 1.0 [get_ports {alu_result[*]}]
set_output_delay -clock sys_clk -min 0.6 [get_ports alu_done]
set_output_delay -clock sys_clk -min 0.5 [get_ports alu_overflow]
set_output_delay -clock sys_clk -min 0.4 [get_ports {combined_status[*]}]

# Max transition time for outputs to prevent signal integrity issues
set_max_transition 0.5 [get_ports {fifo_data_out[*]}]
set_max_transition 0.3 [get_ports fifo_full]
set_max_transition 0.3 [get_ports fifo_empty]
set_max_transition 0.6 [get_ports {alu_result[*]}]
set_max_transition 0.4 [get_ports alu_done]
set_max_transition 0.4 [get_ports alu_overflow]
set_max_transition 0.4 [get_ports {combined_status[*]}]
