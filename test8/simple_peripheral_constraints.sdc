# Simple SDC constraints for peripheral controller IP
# Basic timing constraints for I/O peripherals

# Main peripheral clock constraints
create_clock -name periph_clk_100mhz -period 10.0 [get_ports clk_periph_100mhz]
create_generated_clock -name periph_clk_50mhz -source [get_ports clk_periph_100mhz] -divide_by 2 [get_pins clk_periph_50mhz]

# APB interface timing
set_input_delay -clock periph_clk_100mhz -max 5.0 [get_ports {\apb_if_v2_1/paddr[31:0]}]
set_input_delay -clock periph_clk_100mhz -max 5.0 [get_ports {\apb_if_v2_1/psel_qualified}]
set_input_delay -clock periph_clk_100mhz -max 5.0 [get_ports {\apb_if_v2_1/penable_sync}]
set_input_delay -clock periph_clk_100mhz -max 5.0 [get_ports {\apb_if_v2_1/pwrite_direction}]
set_input_delay -clock periph_clk_100mhz -max 5.0 [get_ports {\apb_if_v2_1/pwdata[31:0]}]

set_output_delay -clock periph_clk_100mhz -max 3.0 [get_ports {\apb_if_v2_1/prdata[31:0]}]
set_output_delay -clock periph_clk_100mhz -max 3.0 [get_ports {\apb_if_v2_1/pready_response}]
set_output_delay -clock periph_clk_100mhz -max 3.0 [get_ports {\apb_if_v2_1/pslverr_indicator}]

# GPIO timing
set_output_delay -clock periph_clk_50mhz -max 2.0 [get_ports {\gpio_bank_A/output_pins[31:0]}]
set_output_delay -clock periph_clk_50mhz -max 2.0 [get_ports {\gpio_bank_A/output_enable[31:0]}]
set_input_delay -clock periph_clk_50mhz -max 4.0 [get_ports {\gpio_bank_A/input_pins[31:0]}]

# SPI timing constraints
set_output_delay -clock periph_clk_50mhz -max 2.5 [get_ports {\spi_master_v3_1_inst0/sclk_out}]
set_output_delay -clock periph_clk_50mhz -max 2.5 [get_ports {\spi_master_v3_1_inst0/mosi_data}]
set_input_delay -clock periph_clk_50mhz -max 4.5 [get_ports {\spi_master_v3_1_inst0/miso_data}]

# UART timing
set_output_delay -clock periph_clk_50mhz -max 1.5 [get_ports uart0_txd_output_registered]
set_input_delay -clock periph_clk_50mhz -max 3.5 [get_ports uart0_rxd_input_synchronized]

# I2C timing (slow interface)
set_false_path -from [get_ports {\i2c_master_v4_1/sda_bidir$pad_control}]
set_false_path -to [get_ports {\i2c_master_v4_1/scl_bidir$pad_control}]

# Clock groups for domain crossing
set_clock_groups -asynchronous -group {periph_clk_100mhz} -group {periph_clk_50mhz}