// Test13 top level - SystemVerilog advanced constructs test - Clean Verilog
module top (
    // Top-level clocks
    input wire clk_a,
    input wire clk_b,
    input wire reset_n,
    
    // External signals (simplified for standard Verilog compatibility)
    input wire [255:0] ext_packed_array,     // 32*8 = 256 bits
    input wire [63:0] ext_multi_dim,         // 4*2*8 = 64 bits  
    input wire [63:0] ext_struct_like,
    input wire [2:0] ext_enum_state,
    
    // AXI-like interface signals
    input wire ext_axi_awvalid,
    input wire [15:0] ext_axi_awaddr,        // Using 16-bit addr from parameter
    input wire [31:0] ext_axi_wdata,         // Using 32-bit data from parameter
    input wire [3:0] ext_axi_wstrb,          // 32/8 = 4 bits
    output wire ext_axi_awready,
    output wire ext_axi_wready,
    
    // Master-slave interface
    input wire ext_master_req,
    input wire [31:0] ext_master_data,
    output wire ext_master_ack,
    input wire ext_slave_req,
    output wire [31:0] ext_slave_data,
    output wire ext_slave_ack,
    
    // Advanced features
    input wire [15:0] ext_queue_size,
    input wire [31:0] ext_dynamic_element,
    output wire [7:0] ext_assoc_key,
    
    // Outputs
    output wire [255:0] ext_packed_array_out,
    output wire [63:0] ext_multi_dim_out,
    output wire [63:0] ext_struct_like_out,
    output wire [2:0] ext_enum_next_state
);

    // SystemVerilog IP instantiation with parameter override
    systemverilog_ip #(
        .DATA_WIDTH(32),
        .ADDR_WIDTH(16),
        .ENABLE_FEATURE(1'b1)
    ) u_systemverilog_ip (
        .clk_domain_a(clk_a),
        .clk_domain_b(clk_b),
        .rst_n(reset_n),
        
        .packed_array_input(ext_packed_array),
        .packed_array_output(ext_packed_array_out),
        
        .multi_dim_input(ext_multi_dim),
        .multi_dim_output(ext_multi_dim_out),
        
        .struct_like_signal(ext_struct_like),
        .struct_like_output(ext_struct_like_out),
        
        .enum_state_signal(ext_enum_state),
        .enum_next_state(ext_enum_next_state),
        
        .axi_awvalid(ext_axi_awvalid),
        .axi_awaddr(ext_axi_awaddr),
        .axi_wdata(ext_axi_wdata),
        .axi_wstrb(ext_axi_wstrb),
        .axi_awready(ext_axi_awready),
        .axi_wready(ext_axi_wready),
        
        .master_req(ext_master_req),
        .master_data(ext_master_data),
        .master_ack(ext_master_ack),
        .slave_req(ext_slave_req),
        .slave_data(ext_slave_data),
        .slave_ack(ext_slave_ack),
        
        .queue_like_signal_size(ext_queue_size),
        .dynamic_array_element(ext_dynamic_element),
        .associative_array_key(ext_assoc_key)
    );

endmodule