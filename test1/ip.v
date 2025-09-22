module ip (
    input  [3:0] din,
    output [3:0] dout
);
    assign dout = din + 1;
endmodule
