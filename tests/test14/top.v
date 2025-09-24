// Comprehensive top-level integration test - Clean implementation
// Testing the comprehensive IP module with proper interconnects
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
    
    // Memory interfaces
    output [31:0] ddr_addr,
    output [127:0] ddr_write_data,
    input [127:0] ddr_read_data,
    output ddr_write_enable,
    output ddr_read_enable,
    input ddr_ready,
    
    // High-speed serial interface (PCIe-like)
    input [7:0] pcie_rx_data,
    output [7:0] pcie_tx_data,
    input pcie_rx_valid,
    output pcie_tx_valid,
    input pcie_rx_ready,
    output pcie_tx_ready,
    
    // Control and status
    input [15:0] ext_control_register,
    output [15:0] ext_status_register,
    output ext_interrupt_signal,
    
    // Performance monitoring
    output [31:0] ext_performance_counter_0,
    output [31:0] ext_performance_counter_1,
    output [31:0] ext_performance_counter_2,
    output [31:0] ext_performance_counter_3
);

    // Reset synchronization
    reg reset_sync_n;
    always @(posedge clk_sys_200mhz or negedge reset_por_n) begin
        if (!reset_por_n)
            reset_sync_n <= 1'b0;
        else
            reset_sync_n <= reset_sys_n;
    end

    // Comprehensive IP instantiation
    comprehensive_ip u_comprehensive_ip (
        .clk_main_200mhz(clk_sys_200mhz),
        .clk_mem_400mhz(clk_ddr_400mhz),
        .clk_pcie_125mhz(clk_pcie_125mhz),
        .clk_usb_60mhz(clk_usb_60mhz),
        .reset_n(reset_sync_n),
        
        // GPIO interface
        .gpio_input_data(ext_gpio_in),
        .gpio_output_data(ext_gpio_out),
        
        // Memory controller interface
        .mem_addr_bus(ddr_addr),
        .mem_write_data(ddr_write_data),
        .mem_read_data(ddr_read_data),
        .mem_write_enable(ddr_write_enable),
        .mem_read_enable(ddr_read_enable),
        .mem_ready(ddr_ready),
        
        // High-speed serial interface
        .serial_rx_data(pcie_rx_data),
        .serial_tx_data(pcie_tx_data),
        .serial_rx_valid(pcie_rx_valid),
        .serial_tx_valid(pcie_tx_valid),
        .serial_rx_ready(pcie_rx_ready),
        .serial_tx_ready(pcie_tx_ready),
        
        // Control and status
        .control_register(ext_control_register),
        .status_register(ext_status_register),
        .interrupt_signal(ext_interrupt_signal),
        
        // Performance monitoring
        .performance_counter_0(ext_performance_counter_0),
        .performance_counter_1(ext_performance_counter_1),
        .performance_counter_2(ext_performance_counter_2),
        .performance_counter_3(ext_performance_counter_3)
    );

endmodule