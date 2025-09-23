# Simple SDC constraints for peripheral controller IP
# Basic timing constraints for I/O peripherals
# Main peripheral clock constraints
create_clock -name periph_clk_100mhz -period 10.0 [get_ports periph_clk_100mhz]
create_generated_clock -name periph_clk_50mhz -source [get_ports periph_clk_100mhz] -divide_by 2 [get_pins /* derived from periph_clk_100mhz u_peripheral_controller_inst1/*/]
# APB interface timing
# GPIO timing
# SPI timing constraints
# UART timing
# I2C timing (slow interface)
set_false_path -from [get_ports {ext_i2c_sda}]
set_false_path -to [get_ports {ext_i2c_scl}]
# Clock groups for domain crossing
set_clock_groups -asynchronous -group {periph_clk_100mhz} -group {periph_clk_50mhz}
