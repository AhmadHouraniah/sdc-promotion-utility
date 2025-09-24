// Top-level module integrating FIFO and ALU
module top_two_ips (
    input  sys_clk,
    input  sys_rst_n,
    
    // FIFO interface
    input  [7:0] f_di,
    input  fifo_wr_en,
    input  fifo_rd_en,
    output [7:0] fifo_data_out,
    output fifo_full,
    output fifo_empty,
    
    // ALU interface  
    input  [15:0] alu_a,
    input  [15:0] alu_b,
    input  [2:0] alu_operation,
    input  alu_start,
    output [15:0] alu_result,
    output alu_done,
    output alu_overflow,
    
    // Combined output
    output [7:0] combined_status
);

    // Clock and reset distribution
    wire fifo_clk, alu_clk;
    wire fifo_rst_n, alu_rst_n;
    
    // Clock buffers (in real design, these would be clock gating or PLLs)
    assign fifo_clk = sys_clk;
    assign alu_clk = sys_clk;
    assign fifo_rst_n = sys_rst_n;
    assign alu_rst_n = sys_rst_n;
    
    // FIFO instance
    ip1 u_fifo (
        .clk(fifo_clk),
        .rst_n(fifo_rst_n),
        .data_in(f_di),
        .wr_en(fifo_wr_en),
        .rd_en(fifo_rd_en),
        .data_out(fifo_data_out),
        .full(fifo_full),
        .empty(fifo_empty)
    );
    
    // ALU instance
    ip2 u_alu (
        .clk(alu_clk),
        .rst_n(alu_rst_n),
        .operand_a(alu_a),
        .operand_b(alu_b),
        .alu_op(alu_operation),
        .valid_in(alu_start),
        .result(alu_result),
        .valid_out(alu_done),
        .overflow(alu_overflow)
    );
    
    // Combined status register
    assign combined_status = {
        fifo_full,      // bit 7
        fifo_empty,     // bit 6
        alu_done,       // bit 5
        alu_overflow,   // bit 4
        4'b0            // bits 3:0 reserved
    };

endmodule
