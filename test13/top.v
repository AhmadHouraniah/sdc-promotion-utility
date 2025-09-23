// Test13 top level - SystemVerilog advanced constructs test
module top (
    // Top-level clocks
    input wire clk_a,
    input wire clk_b,
    input wire reset_n,
    
    // External signals (simplified for standard Verilog compatibility)
    input wire [255:0] ext_packed_array,     // Simplified from packed arrays
    input wire [191:0] ext_multi_dim,       // Simplified from multi-dimensional
    input wire [63:0] ext_struct_like,
    input wire [2:0] ext_enum_state,
    
    // AXI-like interface signals
    input wire ext_axi_awvalid,
    input wire [31:0] ext_axi_awaddr,
    input wire [7:0] ext_axi_awlen,
    input wire [2:0] ext_axi_awsize,
    input wire [1:0] ext_axi_awburst,
    output wire ext_axi_awready,
    
    input wire ext_axi_wvalid,
    input wire [255:0] ext_axi_wdata,
    input wire [31:0] ext_axi_wstrb,
    input wire ext_axi_wlast,
    output wire ext_axi_wready,
    
    output wire ext_axi_bvalid,
    output wire [1:0] ext_axi_bresp,
    input wire ext_axi_bready,
    
    input wire ext_axi_arvalid,
    input wire [31:0] ext_axi_araddr,
    input wire [7:0] ext_axi_arlen,
    input wire [2:0] ext_axi_arsize,
    input wire [1:0] ext_axi_arburst,
    output wire ext_axi_arready,
    
    output wire ext_axi_rvalid,
    output wire [255:0] ext_axi_rdata,
    output wire [1:0] ext_axi_rresp,
    output wire ext_axi_rlast,
    input wire ext_axi_rready,
    
    // Outputs
    output wire [255:0] ext_packed_array_out,
    output wire [191:0] ext_multi_dim_out,
    output wire [63:0] ext_struct_like_out,
    output wire [2:0] ext_enum_next_state
);

    // Generate internal signals
    wire clk_domain_a = clk_a;
    wire clk_domain_b = clk_b;
    
    // Convert external bundles to SystemVerilog IP format
    wire [31:0][7:0] packed_array_input;
    wire [3:0][1:0][7:0] multi_dim_input;
    
    genvar i, j;
    generate
        // Unpack external signals to match SystemVerilog IP
        for (i = 0; i < 32; i = i + 1) begin : unpack_array
            assign packed_array_input[i] = ext_packed_array[8*i+7:8*i];
        end
        
        for (i = 0; i < 4; i = i + 1) begin : unpack_multi
            for (j = 0; j < 2; j = j + 1) begin : unpack_multi_inner
                assign multi_dim_input[i][j] = ext_multi_dim[16*(i*2+j)+7:16*(i*2+j)];
            end
        end
    endgenerate
    
    // Output signals from IP
    wire [31:0][7:0] packed_array_output;
    wire [3:0][1:0][7:0] multi_dim_output;
    
    // Pack output signals for external interface
    generate
        for (i = 0; i < 32; i = i + 1) begin : pack_array_out
            assign ext_packed_array_out[8*i+7:8*i] = packed_array_output[i];
        end
        
        for (i = 0; i < 4; i = i + 1) begin : pack_multi_out
            for (j = 0; j < 2; j = j + 1) begin : pack_multi_out_inner
                assign ext_multi_dim_out[16*(i*2+j)+7:16*(i*2+j)] = multi_dim_output[i][j];
            end
        end
    endgenerate

    // Instantiate the SystemVerilog IP
    systemverilog_ip #(
        .DATA_WIDTH(32),
        .ADDR_WIDTH(16), 
        .ENABLE_FEATURE(1'b1)
    ) ip_inst (
        // Clocks and reset
        .clk_domain_a(clk_domain_a),
        .clk_domain_b(clk_domain_b),
        .rst_n(reset_n),
        
        // Packed arrays
        .packed_array_input(packed_array_input),
        .packed_array_output(packed_array_output),
        
        // Multi-dimensional arrays
        .multi_dim_input(multi_dim_input),
        .multi_dim_output(multi_dim_output),
        
        // Struct-like signals
        .struct_like_signal(ext_struct_like),
        .struct_like_output(ext_struct_like_out),
        
        // Enum signals
        .enum_state_signal(ext_enum_state),
        .enum_next_state(ext_enum_next_state),
        
        // AXI interface signals
        .axi_awvalid(ext_axi_awvalid),
        .axi_awaddr(ext_axi_awaddr),
        .axi_awlen(ext_axi_awlen),
        .axi_awsize(ext_axi_awsize),
        .axi_awburst(ext_axi_awburst),
        .axi_awready(ext_axi_awready),
        
        .axi_wvalid(ext_axi_wvalid),
        .axi_wdata(ext_axi_wdata),
        .axi_wstrb(ext_axi_wstrb),
        .axi_wlast(ext_axi_wlast),
        .axi_wready(ext_axi_wready),
        
        .axi_bvalid(ext_axi_bvalid),
        .axi_bresp(ext_axi_bresp),
        .axi_bready(ext_axi_bready),
        
        .axi_arvalid(ext_axi_arvalid),
        .axi_araddr(ext_axi_araddr),
        .axi_arlen(ext_axi_arlen),
        .axi_arsize(ext_axi_arsize),
        .axi_arburst(ext_axi_arburst),
        .axi_arready(ext_axi_arready),
        
        .axi_rvalid(ext_axi_rvalid),
        .axi_rdata(ext_axi_rdata),
        .axi_rresp(ext_axi_rresp),
        .axi_rlast(ext_axi_rlast),
        .axi_rready(ext_axi_rready)
    );

endmodule