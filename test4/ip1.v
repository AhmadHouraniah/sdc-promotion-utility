// IP1: Simple FIFO Controller
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

    reg [7:0] fifo_mem [0:15];
    reg [3:0] wr_ptr, rd_ptr;
    reg [4:0] count;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 4'b0;
            rd_ptr <= 4'b0;
            count <= 5'b0;
        end else begin
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
        end
    end
    
    assign data_out = fifo_mem[rd_ptr];
    assign full = (count == 16);
    assign empty = (count == 0);
    
endmodule
