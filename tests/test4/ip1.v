module ip1 (
    input  clk,
    input  rst_n,
    input  [7:0] data_in,
    input  wr_en,
    input  rd_en,
    output [7:0] data_out,
    output full,
    output empty
);
    assign data_out = data_in;
    assign full = 1'b0;
    assign empty = 1'b1;
endmodule
