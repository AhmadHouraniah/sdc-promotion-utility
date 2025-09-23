// Comprehensive top-level integration test
// Testing multiple instance types and complex interconnects
module top (
    // External clocking
    input clk_sys_200mhz,
    input clk_ddr_400mhz,
    input clk_pcie_125mhz,
    input clk_usb_60mhz,
    input reset_por_n,
    input reset_sys_n,
    
    // External interfaces
    input [31:0] ext_gpio_in,
    output [31:0] ext_gpio_out,
    inout [15:0] ext_i2c_bus,
    
    // Memory interfaces
    output [31:0] ddr_addr,
    inout [127:0] ddr_data,
    output [3:0] ddr_dm,
    output ddr_cas_n,
    output ddr_ras_n,
    output ddr_we_n,
    
    // PCIe interface
    input [7:0] pcie_rx_data,
    output [7:0] pcie_tx_data,
    input pcie_rx_valid,
    output pcie_tx_valid,
    
    // USB interface
    inout [7:0] usb_data,
    output usb_clk_out,
    input usb_dir,
    output usb_stp,
    input usb_nxt,
    
    // Test and debug
    input scan_enable,
    input scan_clk,
    input [3:0] scan_in,
    output [3:0] scan_out
);

// Instance 1: Unicode edge case IP
unicode_edge_ip u_unicode_test_inst1 (
    .clk_main_domain_100mhz_primary_oscillator(clk_sys_200mhz),
    .clk_auxiliary_domain_50mhz_secondary_pll_output(clk_usb_60mhz),
    .reset_system_wide_asynchronous_active_low_synchronized(reset_sys_n),
    
    .\\signal_with_$_dollar_sign (ext_gpio_in[0]),
    .\\path/to/hierarchical$signal_name (ext_gpio_in[1]),
    .\\very_long_signal_name_that_exceeds_normal_limits_and_continues_for_testing_maximum_length_handling_in_parser (ext_gpio_in[2]),
    .\\ultra_wide_bus_signal_with_1024_bits_for_testing_maximum_length_handling_in_parser ({ext_gpio_in, {992{1'b0}}}),
    
    .\\negative_range_bus_signal ({ext_gpio_in, 8'b0}),
    .\\single_bit_range_signal (ext_gpio_in[7]),
    .\\reversed_range_signal ({ext_gpio_in, {96{1'b0}}}),
    
    .CamelCaseSignalName(ext_gpio_in[8]),
    .snake_case_signal_name(ext_gpio_in[9]),
    .\\mixed$Case/Signal_Name (ext_gpio_in[10]),
    
    .\\signal_123_456_789 (ext_gpio_in[11]),
    .\\signal_with_0x_prefix (ext_gpio_in[12]),
    .\\signal_0123_octal_like (ext_gpio_in[13]),
    
    .\\output_ultra_wide_bus_1024_bits (),
    .\\complex_output$signal/path (ext_gpio_out[0]),
    .\\negative_output_range (),
    
    .\\bidirectional_bus_with_long_name_for_testing_parser_limits (),
    .\\bidir$special/char_signal (ext_i2c_bus[0])
);

// Instance 2: Large scale IP for performance testing
large_scale_ip u_large_scale_inst1 (
    .clk_main_200mhz(clk_sys_200mhz),
    .clk_aux_100mhz(clk_pcie_125mhz),
    .clk_slow_25mhz(clk_usb_60mhz),
    .reset_n(reset_sys_n),
    
    // Connect first 32 signals to external interfaces
    .\\input_data_bus_0000_wide_signal (ext_gpio_in),
    .\\input_data_bus_0001_wide_signal (ddr_addr),
    .\\input_data_bus_0002_wide_signal ({pcie_rx_data, usb_data, ext_gpio_in[15:0]}),
    .\\input_data_bus_0003_wide_signal ({ext_i2c_bus, ext_gpio_in[15:0]}),
    
    .\\output_data_bus_0000_wide_signal (ext_gpio_out),
    .\\output_data_bus_0001_wide_signal (ddr_addr),
    .\\output_data_bus_0002_wide_signal ({pcie_tx_data, usb_data, scan_out, {12{1'b0}}}),
    .\\output_data_bus_0003_wide_signal (),
    
    // Other signals left unconnected for testing
    .\\input_data_bus_0004_wide_signal (32'b0),
    .\\input_data_bus_0005_wide_signal (32'b0),
    // ... (assume other connections exist)
    
    .\\bidir_data_bus_0000_ultra_wide (ddr_data[63:0]),
    .\\bidir_data_bus_0001_ultra_wide ()
    // ... (assume other connections exist)
);

// Instance 3: SystemVerilog IP
systemverilog_ip #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(32),
    .ENABLE_FEATURE(1'b1)
) u_systemverilog_inst1 (
    .clk_domain_a(clk_sys_200mhz),
    .clk_domain_b(clk_ddr_400mhz),
    .rst_n(reset_sys_n),
    
    .packed_array_input(ext_gpio_in),
    .packed_array_output(ext_gpio_out),
    
    .multi_dim_input(ext_gpio_in[7:0]),
    .multi_dim_output(),
    
    .struct_like_signal({ext_gpio_in, ext_gpio_in}),
    .struct_like_output(),
    
    .enum_state_signal(ext_gpio_in[2:0]),
    .enum_next_state(),
    
    // AXI-like interface
    .axi_awvalid(pcie_rx_valid),
    .axi_awaddr({ext_gpio_in[15:0], ext_gpio_in[15:0]}),
    .axi_wdata(ext_gpio_in),
    .axi_wstrb(ext_gpio_in[3:0]),
    .axi_awready(pcie_tx_valid),
    .axi_wready(),
    
    // Master-slave interfaces
    .master_req(usb_dir),
    .master_data(ext_gpio_in),
    .master_ack(usb_stp),
    .slave_req(usb_nxt),
    .slave_data(),
    .slave_ack(),
    
    // Advanced features
    .\\queue_like_signal$size ({ext_gpio_in[15:0]}),
    .\\dynamic_array$element (ext_gpio_in),
    .\\associative_array$key ()
);

// Clock generation and distribution
wire clk_internal_100mhz;
wire clk_internal_50mhz;
wire clk_internal_25mhz;

// Simple clock dividers for testing
reg [3:0] clk_div_counter = 0;
always @(posedge clk_sys_200mhz) begin
    clk_div_counter <= clk_div_counter + 1;
end

assign clk_internal_100mhz = clk_div_counter[0];  // /2
assign clk_internal_50mhz = clk_div_counter[1];   // /4
assign clk_internal_25mhz = clk_div_counter[2];   // /8

// Reset synchronizers
reg [2:0] reset_sync_sys = 3'b000;
reg [2:0] reset_sync_ddr = 3'b000;

always @(posedge clk_sys_200mhz or negedge reset_por_n) begin
    if (!reset_por_n) begin
        reset_sync_sys <= 3'b000;
    end else begin
        reset_sync_sys <= {reset_sync_sys[1:0], 1'b1};
    end
end

always @(posedge clk_ddr_400mhz or negedge reset_por_n) begin
    if (!reset_por_n) begin
        reset_sync_ddr <= 3'b000;
    end else begin
        reset_sync_ddr <= {reset_sync_ddr[1:0], 1'b1};
    end
end

wire reset_sys_sync_n = reset_sync_sys[2] & reset_sys_n;
wire reset_ddr_sync_n = reset_sync_ddr[2] & reset_sys_n;

// Instantiate the comprehensive IP
comprehensive_ip ip_inst (
    // Clock inputs
    .clk_main_200mhz(clk_sys_200mhz),
    .clk_mem_400mhz(clk_ddr_400mhz),
    .clk_pcie_125mhz(clk_pcie_125mhz),
    .clk_usb_60mhz(clk_usb_60mhz),
    .reset_n(reset_sys_sync_n),
    
    // GPIO interface
    .gpio_input_data(ext_gpio_in),
    .gpio_output_data(ext_gpio_out),
    
    // Memory controller interface
    .mem_addr_bus(ddr_addr),
    .mem_write_data(ddr_data[127:0]),
    .mem_read_data(ddr_data[127:0]),
    .mem_write_enable(ddr_we_n),
    .mem_read_enable(ddr_cas_n),
    .mem_ready(~ddr_ras_n),
    
    // High-speed serial interface
    .serial_rx_data(pcie_rx_data),
    .serial_tx_data(pcie_tx_data),
    .serial_rx_valid(pcie_rx_valid),
    .serial_tx_valid(pcie_tx_valid),
    .serial_rx_ready(1'b1),  // Always ready for this test
    .serial_tx_ready(pcie_rx_valid),
    
    // Control and status
    .control_register(ext_i2c_bus[15:0]),
    .status_register(ext_i2c_bus[15:0]),  // Bidirectional for demo
    .interrupt_signal(ext_i2c_bus[15]),   // Use I2C bus bit for demo
    
    // Performance monitoring - not connected externally in this test
    .performance_counter_0(),
    .performance_counter_1(),
    .performance_counter_2(),
    .performance_counter_3()
);

// Test scan chain for DFT
assign scan_out = {scan_in[2:0], scan_enable};
assign usb_clk_out = clk_usb_60mhz;

endmodule