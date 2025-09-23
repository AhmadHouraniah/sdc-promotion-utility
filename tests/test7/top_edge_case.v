// Top-level design for edge case testing
module top_edge_case (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire secondary_clk,
    
    // External I/O - connected to IP
    input wire [7:0] external_data_bus,
    input wire [3:0] control_signals,
    output wire [15:0] chip_output_data,
    output wire chip_status,
    
    // External I/O - bidirectional  
    inout wire [1:0] chip_bidir,
    
    // External async interface
    input wire [31:0] external_async_input,
    
    // Additional top-level only I/O (not connected to IP)
    input wire test_mode,
    output wire [7:0] debug_output
);

    // IP instantiation with complex signal names
    edge_case_ip u_edge_case_processor (
        .clk(sys_clk),
        .rst_n(sys_rst_n),
        .data_in_bus_0(external_data_bus),
        .ctrl_sig_a2b(control_signals),
        .result_out_vec(chip_output_data),
        .status_flag_x(chip_status),
        .bidir_port(chip_bidir),
        .alt_clk(secondary_clk),
        .async_data(external_async_input)
    );
    
    // Additional logic not connected to IP
    reg [7:0] debug_reg;
    always @(posedge sys_clk) begin
        if (!sys_rst_n)
            debug_reg <= 8'h00;
        else if (test_mode)
            debug_reg <= external_data_bus;
    end
    
    assign debug_output = debug_reg;

endmodule