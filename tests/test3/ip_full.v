module ip_full (
    input  [7:0] din_a,
    input  [3:0] din_b,
    output [7:0] dout_a,
    output [3:0] dout_b,
    output ready
);
    assign dout_a = din_a + 1;
    assign dout_b = din_b + 2;
    assign ready = &din_b; // ready when all din_b bits are 1
endmodule
