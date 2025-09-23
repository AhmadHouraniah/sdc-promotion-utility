module ip2 (
    input  clk,
    input  rst_n,
    input  [15:0] operand_a,
    input  [15:0] operand_b,
    input  [2:0] alu_op,
    input  valid_in,
    output [15:0] result,
    output valid_out,
    output overflow
);
    assign result = operand_a;
    assign valid_out = valid_in;
    assign overflow = 1'b0;
endmodule
