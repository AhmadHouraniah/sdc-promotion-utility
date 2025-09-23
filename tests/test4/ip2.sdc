# SDC constraints for IP2 (Pipelined ALU)

# Create clock constraint - 100MHz target frequency
create_clock -name ip2_clk -period 10.0 [get_ports clk]

# Input delays for operands and control
set_input_delay -clock ip2_clk -max 2.5 [get_ports {operand_a[*]}]
set_input_delay -clock ip2_clk -min 0.6 [get_ports {operand_a[*]}]
set_input_delay -clock ip2_clk -max 2.5 [get_ports {operand_b[*]}]
set_input_delay -clock ip2_clk -min 0.6 [get_ports {operand_b[*]}]
set_input_delay -clock ip2_clk -max 1.8 [get_ports {alu_op[*]}]
set_input_delay -clock ip2_clk -min 0.4 [get_ports {alu_op[*]}]
set_input_delay -clock ip2_clk -max 1.5 [get_ports valid_in]
set_input_delay -clock ip2_clk -min 0.3 [get_ports valid_in]

# Output delays for results
set_output_delay -clock ip2_clk -max 3.5 [get_ports {result[*]}]
set_output_delay -clock ip2_clk -min 1.0 [get_ports {result[*]}]
set_output_delay -clock ip2_clk -max 2.2 [get_ports valid_out]
set_output_delay -clock ip2_clk -min 0.6 [get_ports valid_out]
set_output_delay -clock ip2_clk -max 2.0 [get_ports overflow]
set_output_delay -clock ip2_clk -min 0.5 [get_ports overflow]

# Max transition constraints for critical outputs
set_max_transition 0.6 [get_ports {result[*]}]
set_max_transition 0.4 [get_ports valid_out]
set_max_transition 0.4 [get_ports overflow]

# Multicycle path for the ALU computation (2 clock cycles for pipeline)
set_multicycle_path -setup 2 -from [get_ports {operand_a[*] operand_b[*] alu_op[*]}] -to [get_ports {result[*]}]
set_multicycle_path -hold 1 -from [get_ports {operand_a[*] operand_b[*] alu_op[*]}] -to [get_ports {result[*]}]
